Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85DB0695DAF
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 09:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbjBNIzq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 03:55:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjBNIzp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 03:55:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3177C10F
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 00:55:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC238B81BF7
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 08:55:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFCD8C433EF;
        Tue, 14 Feb 2023 08:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676364941;
        bh=unY55RPLsx/WxlqxPR30sWl7xhvgMdGq62LlydVhw0o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K/+nrGn8i5GuFPQVdVVduWs5xHC7mlcguq8fgx29+QGrblAMxNJW+fmmuri7arUZ5
         XqiY/0p9DnNfIsHJX/8Gey8E9Dcs4rJQrqWHamUmiKNmJZJlrknZbWTAkS3OmF9qll
         YKsWOESgaGV9jpnstauLOStz9e7tObGUmaclJ75A=
Date:   Tue, 14 Feb 2023 09:55:39 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     akpm@linux-foundation.org, david@redhat.com, jthoughton@google.com,
        mhocko@suse.com, naoya.horiguchi@linux.dev, peterx@redhat.com,
        shy828301@gmail.com, songmuchun@bytedance.com,
        stable@vger.kernel.org, vishal.moola@gmail.com, willy@infradead.org
Subject: Re: FAILED: patch "[PATCH] migrate: hugetlb: check for hugetlb
 shared PMD in node" failed to apply to 5.4-stable tree
Message-ID: <Y+tMi9wrXJuI8WTR@kroah.com>
References: <1675761364213238@kroah.com>
 <Y+riPN74R68GOaGU@monkey>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+riPN74R68GOaGU@monkey>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 13, 2023 at 05:22:04PM -0800, Mike Kravetz wrote:
> On 02/07/23 10:16, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Updated patch below.  Note that this depends on backport of upstream
> commit 3489dbb696d25602aea8c3e669a6d43b76bd5358 which is already queued
> up for 5.4-stable tree.

All now queued up, thanks!

greg k-h
