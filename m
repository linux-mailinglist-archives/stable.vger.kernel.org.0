Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDA8E6DA79F
	for <lists+stable@lfdr.de>; Fri,  7 Apr 2023 04:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240370AbjDGCRn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 22:17:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240352AbjDGCRl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 22:17:41 -0400
Received: from ci74p00im-qukt09090302.me.com (ci74p00im-qukt09090302.me.com [17.57.156.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A50A173E
        for <stable@vger.kernel.org>; Thu,  6 Apr 2023 19:17:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sladewatkins.net;
        s=sig1; t=1680833442;
        bh=vgenMfSKtRXgiUIp+hur8G/7yMe0DexN9fQK0YxzSqA=;
        h=Content-Type:Mime-Version:Subject:From:Date:Message-Id:To;
        b=iNU3vhm7giVjM2QeiE9i1UqQKgwqYFdCtwELxeEr27kt5G/iBaXvj9wbI/CDBRKuY
         aSZ0anuOLJAfaME4eUXWzROgGeE03OrAhgHTvKf7W0NQVuue1z1eclqPWwSS1rIFmk
         dDuIFI6CUE1GqMNc9DFt2q1WxVnd7sCaztoDUVG5/iXnjV/0IYgyCPpLpc9QKZ8vOh
         FAi7t4zd/ZdRBBPT5ScIRaX1LLuNZf2DbAGBkdVD6vTbG3q5JQ/VXomZqBLLfaQlW4
         tyBhRxI7e27yyffBlYqDyjCc9Uq3+JEyK2SBAMwHd84qYpirZ5sGBtwiUkdqtVvb3a
         dL/ejp87XPFeg==
Received: from smtpclient.apple (ci77p00im-dlb-asmtp-mailmevip.me.com [17.57.156.26])
        by ci74p00im-qukt09090302.me.com (Postfix) with ESMTPSA id D315B5BC02CC;
        Fri,  7 Apr 2023 02:10:40 +0000 (UTC)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: [PATCH 6.1 000/177] 6.1.23-rc3 review
From:   srw@sladewatkins.net
In-Reply-To: <20230405100302.540890806@linuxfoundation.org>
Date:   Thu, 6 Apr 2023 22:10:40 -0400
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux@roeck-us.net,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de
Content-Transfer-Encoding: quoted-printable
Message-Id: <CD9890B4-8C49-4616-B9DA-2408A60B73FF@sladewatkins.net>
References: <20230405100302.540890806@linuxfoundation.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.3731.500.231)
X-Proofpoint-ORIG-GUID: Rz5-JXVxHCEyox4VTgX5CpVCIltQYCl2
X-Proofpoint-GUID: Rz5-JXVxHCEyox4VTgX5CpVCIltQYCl2
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.138,18.0.790,17.11.62.513.0000000_definitions?=
 =?UTF-8?Q?=3D2022-01-12=5F03:2020-02-14=5F02,2022-01-12=5F03,2021-12-02?=
 =?UTF-8?Q?=5F01_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 adultscore=0
 malwarescore=0 bulkscore=0 spamscore=0 suspectscore=0 clxscore=1030
 mlxlogscore=698 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2304070018
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Apr 5, 2023, at 6:03 AM, Greg Kroah-Hartman =
<gregkh@linuxfoundation.org> wrote:
>=20
> This is the start of the stable review cycle for the 6.1.23 release.
> There are 177 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, =
please
> let me know.
>=20
> Responses should be made by Fri, 07 Apr 2023 10:02:26 +0000.
> Anything received after that time might be too late.


This compiles and boots on x86_64 with no errors or regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

Slade=
