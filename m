Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 732D1645467
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 08:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbiLGHNH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 02:13:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbiLGHNG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 02:13:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B8E92184;
        Tue,  6 Dec 2022 23:13:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDBEB60920;
        Wed,  7 Dec 2022 07:13:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E3AC433C1;
        Wed,  7 Dec 2022 07:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670397184;
        bh=SnJZwq6XZGUWZpNuhmRFN9PiqDjOfH6NdVQmGbm/GY0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cc4WU7G0EPGsDWR3dst6hcxPjyPoqgAWsnMbOGBVceuz8I5RcvSs9QjUsN+3TmNjf
         Qg6o2hkNSw2ifvUd3UknLJIYJdeV/hmjWumJkE7JjdCnYt9OrKN7PBjJme7tg9et5e
         j82uLTs6nww9LE580XZTb/ugHgCeZDjNnvy3knl0=
Date:   Wed, 7 Dec 2022 08:13:01 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dicheng Wang <wangdicheng123@hotmail.com>
Cc:     alsa-devel@alsa-project.org, connerknoxpublic@gmail.com,
        hahnjo@hahnjo.de, john-linux@pelago.org.uk,
        linux-kernel@vger.kernel.org, sdoregor@sdore.me,
        stable@vger.kernel.org, tiwai@suse.com, wangdicheng@kylinos.cn
Subject: Re: [PATCH v3 -next] ALSA:usb-audio:add the information of KT0206
 device driven by USB audio
Message-ID: <Y5A8/bpWoG4Dp2Nx@kroah.com>
References: <Y480pd/XynYddrHk@kroah.com>
 <SG2PR02MB58789FBF9A2EA801AF49D5E88A1A9@SG2PR02MB5878.apcprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SG2PR02MB58789FBF9A2EA801AF49D5E88A1A9@SG2PR02MB5878.apcprd02.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 07, 2022 at 11:20:23AM +0800, Dicheng Wang wrote:
> From: wangdicheng <wangdicheng@kylinos.cn>

This name and email address does not match the name on the From: line.
Please work with your company to allow you to send out kernel patches
properly, spoofing through a hotmail.com address is not something that
your company wants to have happen, as anyone can impersonate an address
from them (and this one doesn't even pass basic email verification
checks) :(

thanks,

greg k-h
