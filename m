Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0055261EB5E
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 08:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbiKGHOe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 02:14:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbiKGHOe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 02:14:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC4712A82
        for <stable@vger.kernel.org>; Sun,  6 Nov 2022 23:14:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0174360EF3
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 07:14:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE7DCC433D6;
        Mon,  7 Nov 2022 07:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667805272;
        bh=/CKlzvi4Fxp/kQHs/EzlDa5U3bpFmjPwIVjOUnageUk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H2jNNGXhgyaVaQh5HcXIBj2Pt5OAIH8OIYV8JQXFsoth5EmWtak3mAE+LEpf7a8Lk
         ANt8mno2VmpOxeufdRG82kJx6K/cWJyZ7a3Pt0/2Wc0053UB668Vt/Rcc4kcu8kxL/
         c7bb55h1QkWoRuaHuFSH9VrFDIA0WsBCOCRS9Qj8=
Date:   Mon, 7 Nov 2022 08:14:29 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     malaizhichun <malaizhichun@tom.com>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: This is about the acip-bios problem
Message-ID: <Y2iwVT44/T1cofZG@kroah.com>
References: <39ebab39-fb03-4be4-ec00-c5665f19fbdd@tom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <39ebab39-fb03-4be4-ec00-c5665f19fbdd@tom.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 07, 2022 at 09:25:51AM +0800, malaizhichun wrote:
> Please what time  the acpi-bios error reported by the dmesg command will be
> fixed, it's really annoying. I have never been able to eliminate such
> reports, it's only to insert loglevel=3 in grub settings to block. But it
> doesn't solve the problem, and  I use google search , it's tells me that fix
> this problem need a bios upgrade, but actually my hardware has  stopped
> upgrade, so I don't know how to do fix this, thanks

Please discuss this on the acpi mailing list, the developers there will
be able to help you out.

good luck!

greg k-h
