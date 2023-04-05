Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6B266D828B
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 17:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239071AbjDEPu1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 11:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239129AbjDEPuM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 11:50:12 -0400
Received: from mail.antaris-organics.com (mail.antaris-organics.com [91.227.220.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E9416A6D;
        Wed,  5 Apr 2023 08:49:53 -0700 (PDT)
Received: by mail.antaris-organics.com (Postfix, from userid 200)
        id 84F4C45BD1; Wed,  5 Apr 2023 17:53:11 +0200 (CEST)
Date:   Wed, 5 Apr 2023 17:47:40 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mareichelt.com;
        s=202107; t=1680709661;
        bh=ZxydYoGLePcgBK20Y7PRCnl2LGIwb11ZNltBaQAjU1U=;
        h=Date:From:To:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To:Cc:Cc:content-type:content-type:date:date:
         From:from:in-reply-to:in-reply-to:message-id:mime-version:
         references:reply-to:Sender:Subject:Subject:To:To;
        b=HQ2S2wPDP4FFabaCCem8XM5WKNZY4KJVSvsXMFG29/FD2XYzc8nGQIUYUH2MS+K96
         YWNYHrRmQF7Od7/sckFCEZOsK3HGrVSwMZx2w762CfgBz9FwHNJSvMx9xj1/kLV951
         Lmr6iTwNGIvrGP1jRV3mbwd4rbRKJcmsFDGOEysFRonGkthM3URN5LR9XDsLsrXQSM
         gRT3OH0g45wwioZcK458Hdrx4WWOEakEbXIjBUJD1ayFtc8/OfBX5tgPa+YLmjXIFc
         QRvHEXPinayplahD/D55Ehm7BVwy5RTtXBbZdVu5NlpjSDHaZF7KKm+acu8YKNGtM1
         3OokIHhD0wsew==
From:   Markus Reichelt <lkt+2023@mareichelt.com>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.1 000/177] 6.1.23-rc3 review
Message-ID: <20230405154740.GD5308@pc21.mareichelt.com>
Mail-Followup-To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230405100302.540890806@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405100302.540890806@linuxfoundation.org>
Organization: still stuck in reorganization mode
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.1.23 release.
> There are 177 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 Apr 2023 10:02:26 +0000.
> Anything received after that time might be too late.

Hi Greg

6.1.23-rc3

compiles, boots and runs here on x86_64
(AMD Ryzen 5 PRO 4650G, Slackware64-15.0)

Tested-by: Markus Reichelt <lkt+2023@mareichelt.com>
