Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D592A592F56
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 15:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbiHONEF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 09:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232483AbiHONED (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 09:04:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3790218397
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 06:04:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9513B80D2B
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 13:04:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4367AC433D7;
        Mon, 15 Aug 2022 13:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660568639;
        bh=xcvsRF5/o+xH+MzrX5F0r66GchZOkXIK+HT0NwJ2VKw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F1jTQ2dfYAfeYtBppwi/590zOOUbQUjDUvVWINvzrupyTVWIhsaKfnoxAW9fublE0
         T6kKoRUJrJ6r9Qa7bHGp3N1nP+UJm7gGy4eC1Utt3M2nE3yNAXHQUvAmDNsj4y89mv
         oRSyEkATvSx/uqae4vnYhAOjVReS4RoAUS+Mog5c=
Date:   Mon, 15 Aug 2022 15:03:56 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
Cc:     coxu@redhat.com, bhe@redhat.com, ebiederm@xmission.com,
        zohar@linux.ibm.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] kexec: clean up
 arch_kexec_kernel_verify_sig" failed to apply to 5.15-stable tree
Message-ID: <YvpEPMGebrrhp8Yf@kroah.com>
References: <1660564084173149@kroah.com>
 <20220815124125.GD17705@kitsune.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220815124125.GD17705@kitsune.suse.cz>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 15, 2022 at 02:41:25PM +0200, Michal Suchánek wrote:
> Hello,
> 
> it applies on top of 105e10e2cf1c

I see no such commit id in Linus's tree, what am I missing here?

confused,

greg k-h
