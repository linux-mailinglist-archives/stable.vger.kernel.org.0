Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E28ED669CEB
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 16:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbjAMPwI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 10:52:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbjAMPui (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 10:50:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C62065AF0;
        Fri, 13 Jan 2023 07:43:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2F3761FC3;
        Fri, 13 Jan 2023 15:43:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD5D1C433F1;
        Fri, 13 Jan 2023 15:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673624633;
        bh=RDtldCHhOU3Bo3pJibaZpOM4uT1+p0yui2PnCg+as8o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ONzkQ7gZ51JUMsLapq5pmDiXaYOsJLLKodE1n30W6DeD/hxkiGhdhnuDXGP90YlbB
         JSI9yUyvBZb3c/HDy6J4IQU80Ff8wPYSMi+gmsG4rZWTUwkdOG3YqVNsK35QKS5SvD
         /pVuMIR7QPeHSFYlgmpFIzfAUvBV3uYCbkPFXmZw=
Date:   Fri, 13 Jan 2023 16:43:19 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, Clement Lecigne <clecigne@google.com>
Subject: Re: [PATCH 5.10.y] ALSA: pcm: Properly take rwsem lock in
 ctl_elem_read_user/ctl_elem_write_user to prevent UAF
Message-ID: <Y8F8F9MpNR4O8kbB@kroah.com>
References: <20230113142639.4420-1-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113142639.4420-1-tiwai@suse.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 13, 2023 at 03:26:39PM +0100, Takashi Iwai wrote:
> From: Clement Lecigne <clecigne@google.com>
> 
> [ Note: this is a fix that works around the bug equivalently as the
>   two upstream commits:
>    1fa4445f9adf ("ALSA: control - introduce snd_ctl_notify_one() helper")
>    56b88b50565c ("ALSA: pcm: Move rwsem lock inside snd_ctl_elem_read to prevent UAF")
>   but in a simpler way to fit with older stable trees -- tiwai ]

Thanks for the backport, now queued up.

greg k-h
