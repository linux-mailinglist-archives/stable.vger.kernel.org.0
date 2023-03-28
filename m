Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 909326CCA55
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 20:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbjC1S4s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 14:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjC1S4s (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 14:56:48 -0400
Received: from mail.antaris-organics.com (mail.antaris-organics.com [91.227.220.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C7DA2139;
        Tue, 28 Mar 2023 11:56:46 -0700 (PDT)
Date:   Tue, 28 Mar 2023 20:56:44 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mareichelt.com;
        s=202107; t=1680029805;
        bh=wejfUIio3uPTL6FzX/Vr/ib7zk6hDg26IUkB2ecV+B8=;
        h=Date:From:To:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To:Cc:Cc:content-type:content-type:date:date:
         From:from:in-reply-to:in-reply-to:message-id:mime-version:
         references:reply-to:Sender:Subject:Subject:To:To;
        b=q4JTcntQEaT8XWZx8GckLD3WdxDgKKWBsOhhg1pKgaI8pDcDnCVXovN3Xr5/w5vJ2
         3AGQpX9Fpm0RcjW/e72jRm2GQp6TCS9JyEBTEl8XEtBZspy0Ifk39QaDLnnLJRxO5V
         ukTLKs5uupWtv3wfkUzq38FV228226DF8n8oCDWtAItd7bcBfQDjb5E0urugWp2zR+
         gxa1AwEZ1cM66PKJ8BPRhSH0RdMfxwWnIKTAr10cxzyUuBG29D8x2JP/mBXKBLUrr+
         aEKloUD1oOAb2uWDoh8sXMO6sxpDs7d6oBVnQoh8fWzlZcDqOt/9W0jYNnn6F+gIqR
         C4E5OnuoHPZmQ==
From:   Markus Reichelt <lkt+2023@mareichelt.com>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.1 000/224] 6.1.22-rc1 review
Message-ID: <20230328185644.GA2455@pc21.mareichelt.com>
Mail-Followup-To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230328142617.205414124@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
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

> This is the start of the stable review cycle for the 6.1.22 release.
> There are 224 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Mar 2023 14:25:33 +0000.
> Anything received after that time might be too late.

Hi Greg

6.1.22-rc1

compiles, boots and runs here on x86_64
(AMD Ryzen 5 PRO 4650G, Slackware64-15.0)

Tested-by: Markus Reichelt <lkt+2023@mareichelt.com>
