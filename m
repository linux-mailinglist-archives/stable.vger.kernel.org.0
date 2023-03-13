Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A283C6B7219
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 10:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbjCMJKB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 05:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbjCMJJr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 05:09:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA745614C;
        Mon, 13 Mar 2023 02:08:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7B9DB80E46;
        Mon, 13 Mar 2023 09:08:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFB4DC433EF;
        Mon, 13 Mar 2023 09:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678698518;
        bh=D68iX5XocJ4Nym6PlfJ0HZhOyF9bNMkuEXEB0RJBxo4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JZ9UQQElklAlEpj5e5qSxeSP6EbOmLXbeQHAACtZnxGxD9AkBv+maO3tontzNNQea
         FRHQyHtD8PtQ01Um3pzRg6MMpH89J2wjz5dG018RzT7+nTQuKXcfQ2tySv9IjF1WrC
         IC/FvxKbDQrwtUviCFVJN6OdgmJobKmxdu0sKTdGgA5o3hmRzm6p9ZATq/Jht02eHL
         utHAY6z7gw167nspOE7LIt+kKgwIEkilQy5mkaKhbVb6RV6NgdNS7qCiQ2u/6pJExd
         0ytAJBUydv9xAvI8a9N8UGUKCJ353PS9ZQuic8GbLqrioosKqsZGEg5jklNq0iYpQz
         XoZKH0rDAlm3w==
Date:   Mon, 13 Mar 2023 09:08:34 +0000
From:   Lee Jones <lee@kernel.org>
To:     stable@vger.kernel.org
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: HID: Stable backport request (all viable versions)
Message-ID: <20230313090834.GA1217438@google.com>
References: <CAHk-=wii6BZtVKYfvQCQqbE3+t1_yAb-ea80-3PcJ4KxgpfHkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHk-=wii6BZtVKYfvQCQqbE3+t1_yAb-ea80-3PcJ4KxgpfHkA@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Stable,

On Sun, 12 Mar 2023, Linus Torvalds wrote:

> It's another Sunday afternoon. which must mean another rc release.
>
> This one looks fairly normal, although if you look at the diffs, they
> are dominated by the removal of a staging driver (r8188eu) that has
> been superceded by a proper driver. That removal itself is 90% of the
> diffs.
>
> But if you filter that out, it all looks normal. Still more than two
> thirds in drivers, but hey, that's pretty normal. It's mostly gpu and
> networking as usual, but there's various other driver fixes in there
> too.
>
> Outside of that regular driver noise (and the unusual driver removal
> noise) it's a little bit of everything: core networking, arch fixes,
> documentation, filesystems (btrfs, xfs, and ext4, but also some core
> vfs fixes). And io_uring and some tooling.
>
> The full shortlog is appended, for the adventurous souls that want to
> get that kind of details. The release feels fairly normal so far, but
> it's early days. Please keep testing and reporting any issues,
>
>                  Linus
>
> ---

> Lee Jones (2):
>       HID: core: Provide new max_buffer_size attribute to over-ride the default
>       HID: uhid: Over-ride the default maximum data buffer value with our own

These 2 are now in Mainline:

  b1a37ed00d790 HID: core: Provide new max_buffer_size attribute to over-ride the default
  1c5d4221240a2 HID: uhid: Over-ride the default maximum data buffer value with our own

Please could you add them to Stable, as far bask as they'll go please.

I'll take a look at any conflicts.

--
Lee Jones [李琼斯]
