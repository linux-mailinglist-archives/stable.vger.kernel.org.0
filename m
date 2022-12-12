Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB4E6498DB
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 07:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbiLLGJJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 01:09:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbiLLGJI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 01:09:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B32DCE20
        for <stable@vger.kernel.org>; Sun, 11 Dec 2022 22:09:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33044B80B4C
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 06:09:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66989C433EF;
        Mon, 12 Dec 2022 06:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670825344;
        bh=sXTEdcjFgX+P1L6gG79UFFvp17reKTGVLfE1mpYfDAg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pLzfyIJqja32wvjG240xt3FyjDOSBl5Basupar0xOq5VKg6GNmtVA9O1kNT1ZM1Zv
         Vf27zOcYaK9wTOsw0zJyn1MVYisIzcj4idG5yzTnN6aNQ3aE626Eseq+phD9y03RwC
         hVT9t6pma2iGQuM3RqpaUX0fHMUHtCt5fLIZVkmU=
Date:   Mon, 12 Dec 2022 07:09:00 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     John Aron <john@aronetics.com>
Cc:     stable@vger.kernel.org
Subject: Re: Slackware 15 on Blade 14
Message-ID: <Y5bFfM1rJ7flFDED@kroah.com>
References: <00a801d90db3$7b121530$71363f90$@aronetics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00a801d90db3$7b121530$71363f90$@aronetics.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 11, 2022 at 05:54:08PM -0500, John Aron wrote:
> Happy Sunday, I have a kernel bug to report.
> 
> It occurs and is repeatable on this Razer Blade 14. This laptop is Slackware
> 15 and using the 5.15.19 kernel. I have attached my core file which is a bad
> name as I cut possibly irrelevant segments from the 'dmesg.'

Great, but can you try the latest 6.0 kernel or 6.1 and then send this
information to the graphics developers mailing list who can help you
out?

thanks,

greg k-h
