Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B37836ED552
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 21:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbjDXTXP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 15:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232645AbjDXTXL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 15:23:11 -0400
Received: from mail.antaris-organics.com (mail.antaris-organics.com [91.227.220.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA036A41;
        Mon, 24 Apr 2023 12:23:08 -0700 (PDT)
Date:   Mon, 24 Apr 2023 21:23:06 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mareichelt.com;
        s=202107; t=1682364187;
        bh=g9Bf20/qMc2OB6MMg0cyi6UlhC5IxljL/FeRIJ4AgcI=;
        h=Date:From:To:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To:Cc:Cc:content-type:content-type:date:date:
         From:from:in-reply-to:in-reply-to:message-id:mime-version:
         references:reply-to:Sender:Subject:Subject:To:To;
        b=0tQ/VRhHjLCChVqKbjk9ysa8wYp5cI8c9tQYCltWOsM8pJxnr4xEqlyzBTwFwjXAJ
         VnAMDZBUVUy+MByvZY8R9GrywO0L6s7R+Hm4jZhPcTAdbptm9/c4ssejitisldqlp2
         VrIS4WEJbph+W9MnfTZxPbrVB2ETu9hm801G/iGJM6Zvsff4JjROOud6WTLcIIY/De
         2tR9hGaOYD7Qg35SPmyaFZX86H9YxfswAnA+L29P5RqaPPK5BlWi3uQLWCjtqjpgH8
         WBQmrrO6kkWIgEKJHkV520bzlAXoCrf4qwEQ2dvnzjdshLRpZj/6jda7wE5uhXexj0
         NAox1QLSdFU7w==
From:   Markus Reichelt <lkt+2023@mareichelt.com>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.2 000/110] 6.2.13-rc1 review
Message-ID: <20230424192306.GC3798@pc21.mareichelt.com>
Mail-Followup-To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230424131136.142490414@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
Organization: still stuck in reorganization mode
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.2.13 release.
> There are 110 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.

Hi Greg

6.2.13-rc1

compiles, boots and runs here on x86_64
(AMD Ryzen 5 PRO 4650G, Slackware64-15.0)

Tested-by: Markus Reichelt <lkt+2023@mareichelt.com>
