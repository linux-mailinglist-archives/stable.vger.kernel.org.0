Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 932676E0406
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 04:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbjDMCRv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 22:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjDMCRt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 22:17:49 -0400
Received: from ci74p00im-qukt09082302.me.com (ci74p00im-qukt09082302.me.com [17.57.156.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA04961BF
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 19:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sladewatkins.net;
        s=sig1; t=1681352267;
        bh=yFrXvH8+6qW3bma8qYo+SSJDTVohuGpOF+VWeDbjTNY=;
        h=Content-Type:Mime-Version:Subject:From:Date:Message-Id:To;
        b=LoBiwxh0zZ7HyCZ9LrNAktzMqgNz4J4iYpYwuvFa0VtsMRaDfp/joOWnjKNbGyNrm
         cUjgBxtk+3f2BZL9pVcDeP3k+J6uOedE+PINJZSBFxhM50Bx72cZdnzVxfgEkdTsKT
         9eeB2EULjK9F9pnk2FcVMIYh7iL/Mh7u2lSZWGxPyyXv9GKwXdMo49E3XfH8EyB3SY
         O+8w04LnrwqGTHUSYsIXj0hoOXHxJmcycg9vjAtoQUqSlTEuUljdqpnsZdpaxy8ETh
         1AvMPw00F39aCFcKvxMm8IcxE21ZiXXd4Bd/g71oTGf4wfle6cSbqiXRlaCi+47Pdq
         esX+MVj4jgMYw==
Received: from smtpclient.apple (ci77p00im-dlb-asmtp-mailmevip.me.com [17.57.156.26])
        by ci74p00im-qukt09082302.me.com (Postfix) with ESMTPSA id D0F2F2FC02B3;
        Thu, 13 Apr 2023 02:17:44 +0000 (UTC)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: [PATCH 6.1 000/164] 6.1.24-rc1 review
From:   Slade Watkins <srw@sladewatkins.net>
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
Date:   Wed, 12 Apr 2023 22:17:43 -0400
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>, rwarsow@gmx.de
Content-Transfer-Encoding: quoted-printable
Message-Id: <C9920C31-41F9-4AC8-B0DC-50A89BC5964E@sladewatkins.net>
References: <20230412082836.695875037@linuxfoundation.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.3731.500.231)
X-Proofpoint-GUID: -qh5ZCfeGIniUCX2jjViAYdrisU8MVHk
X-Proofpoint-ORIG-GUID: -qh5ZCfeGIniUCX2jjViAYdrisU8MVHk
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.138,18.0.572,17.11.62.513.0000000_definitions?=
 =?UTF-8?Q?=3D2020-02-14=5F11:2020-02-14=5F02,2020-02-14=5F11,2021-12-02?=
 =?UTF-8?Q?=5F01_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 clxscore=1030 adultscore=0
 phishscore=0 malwarescore=0 mlxlogscore=569 suspectscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2304130019
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> On Apr 12, 2023, at 4:32 AM, Greg Kroah-Hartman =
<gregkh@linuxfoundation.org> wrote:
>=20
> This is the start of the stable review cycle for the 6.1.24 release.
> There are 164 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, =
please
> let me know.
>=20
> Responses should be made by Fri, 14 Apr 2023 08:28:02 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> =
https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.24-rc=
1.gz
> or in the git tree and branch at:
> =
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git =
linux-6.1.y
> and the diffstat can be found below.
>=20
> thanks,
>=20
> greg k-h


Compiled & booted on two of my x86_64 test systems, no errors or =
regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net =
<mailto:srw@sladewatkins.net>>

Slade=
