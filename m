Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C925049E1D6
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 13:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234911AbiA0MCK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 07:02:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231708AbiA0MCK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 07:02:10 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6786C061714
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 04:02:09 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id bu18so4877704lfb.5
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 04:02:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=embecosm.com; s=google;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=XhtvzHGLBTlHpgrsVt3OxS8UVSEEinBsRKFFK6183gw=;
        b=IHkYvyCfXxjCcI/B0J026dwMFYf3c1NuWIoEe38pk6d2ACqUDabo0owYPl2fJU4TeY
         swIDSeuC9cvxhEh1N0D7O3C+9+eLXXadIZFM+VJDVn/2bo+qkdTvkwJ5a1SNy5xl4cJW
         Daglgp/Z41BMgAzF+nCBQr+FFkZS1RTiP2o/17fs/CzJfTDNveN4n7drY7xEkrnS6SSr
         gnKRmNY9Hjqz1kRWcSPKAArICMYDFs+YjSne6STSjDbfVX6andi7fZFcboCYZJOX/4LG
         D4Gi6u1I4nZB64AcFlKLqd0/TBXdffzMye/l75QKVW+aXuuf+It4zwxyvbJve3qmO2oA
         YXMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=XhtvzHGLBTlHpgrsVt3OxS8UVSEEinBsRKFFK6183gw=;
        b=wEUiUai6pnQjOEpqcPpOeW/xt/T2q3ml7HUWNzoJAOYT0zd/1UCndDABfwsFFoau9b
         NCkrPlsJezT2Zh5vqh68dO3ZezCJQLyvCuhhOdt1u47xF+1KxetVNByQVoJb8pqIgYh8
         UqqUB+GjsEDPTwhRtpFIgGyctqn5gglemV6N3B5BxBI04BC43PLcst6IVVBv5FWmxnht
         lxCG570SFS2X/3M7FRhlk5o13Yb+zZ40EIfK1F+cXDott2u9bXUGQL8Y9xYMHKCGQ2U0
         iWLtss3fxCJnrWWj7gSNPeG7MhCcsW8421guQMyzPVikLxtFBz51b+qKd48uQ63I02Jf
         RVgg==
X-Gm-Message-State: AOAM5317GbHjnDNhjP6YntQAMcOtzfqpi4pIRyoKjeKQ2f1/neDHrae/
        xUIolBW+W8onp4C4hwyv2pY1IQ==
X-Google-Smtp-Source: ABdhPJyQHW7VSjqdBiGLJfRPwoDOEyTxeMELd3EAIlBU/fag1qkrSPxfGQ95u+TaDFjU7N8K6tDA6A==
X-Received: by 2002:a05:6512:238c:: with SMTP id c12mr2612318lfv.333.1643284928123;
        Thu, 27 Jan 2022 04:02:08 -0800 (PST)
Received: from [192.168.219.3] ([78.8.192.131])
        by smtp.gmail.com with ESMTPSA id n20sm835673ljg.136.2022.01.27.04.02.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jan 2022 04:02:07 -0800 (PST)
Date:   Thu, 27 Jan 2022 12:02:02 +0000 (GMT)
From:   "Maciej W. Rozycki" <macro@embecosm.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] kbuild: remove include/linux/cyclades.h from header file
 check
In-Reply-To: <20220127073304.42399-1-gregkh@linuxfoundation.org>
Message-ID: <alpine.DEB.2.20.2201271201010.11348@tpp.orcam.me.uk>
References: <20220127073304.42399-1-gregkh@linuxfoundation.org>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 27 Jan 2022, Greg Kroah-Hartman wrote:

> The file now rightfully throws up a big warning that it should never be
> included, so remove it from the header_check test.

 Thanks, I wasn't aware we have this stuff.

  Maciej
