Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E71765F3082
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 14:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbiJCMw3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 08:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiJCMw2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 08:52:28 -0400
Received: from premium237-5.web-hosting.com (premium237-5.web-hosting.com [66.29.146.205])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D79A645F64;
        Mon,  3 Oct 2022 05:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sladewatkins.net; s=default; h=To:References:Message-Id:
        Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Subject:Mime-Version:
        Content-Type:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=BwfnLXXRIMS5QpEMcBggGTAcX0BVxzdtet8PAoxQa+M=; b=qmV00HecfFtvPGEWKUkApefnMb
        8+AmpAHvbB5+fGt/ncZ0Q+Vz0RhdQ8Uhsz7Y8FPUK6Wpq6BJYc+DX4Omk0n0Gg8cIIgCw8rclxKNt
        EChkd4iGxxSmSqiogTs531y8N3d1e3Rqztp2WDSI8A8rwIWglBlvIH48mC8fYFe025IR1gnNHsZbD
        IGKLtdeRsOWosX0MEKdzNSNNZ35M3Hm63KYoG1NeJp1VgDWGYmhxruYFek44jSwxfInMit1/r2KEO
        5BBrGu37wBmFhb8OisMVjnrUPXd8PbKYsm00snsC1GeccNux9leuMU9gpVLHqJxm2ODdNWbyXx5uz
        eh2XOX5A==;
Received: from pool-108-4-135-94.albyny.fios.verizon.net ([108.4.135.94]:58137 helo=smtpclient.apple)
        by premium237.web-hosting.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <srw@sladewatkins.net>)
        id 1ofKvR-009Fcx-L9;
        Mon, 03 Oct 2022 08:52:01 -0400
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH 4.19 00/25] 4.19.261-rc1 review
From:   Slade Watkins <srw@sladewatkins.net>
In-Reply-To: <20221003070715.406550966@linuxfoundation.org>
Date:   Mon, 3 Oct 2022 08:51:57 -0400
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <CA20B2D8-E42D-4A24-815B-667159FC5D07@sladewatkins.net>
References: <20221003070715.406550966@linuxfoundation.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - premium237.web-hosting.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - sladewatkins.net
X-Get-Message-Sender-Via: premium237.web-hosting.com: authenticated_id: srw@sladewatkins.net
X-Authenticated-Sender: premium237.web-hosting.com: srw@sladewatkins.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-From-Rewrite: unmodified, already matched
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> On Oct 3, 2022, at 3:12 AM, Greg Kroah-Hartman =
<gregkh@linuxfoundation.org> wrote:
>=20
> This is the start of the stable review cycle for the 4.19.261 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, =
please
> let me know.
>=20
> Responses should be made by Wed, 05 Oct 2022 07:07:06 +0000.
> Anything received after that time might be too late.

4.19.261-rc1 compiled and booted with no errors or regressions on my =
x86_64 test system.

Tested-by: Slade Watkins <srw@sladewatkins.net>

-srw

