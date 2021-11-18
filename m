Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A69455D84
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 15:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232571AbhKROLv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 09:11:51 -0500
Received: from ofcsgdbm.dwd.de ([141.38.3.245]:41801 "EHLO ofcsgdbm.dwd.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232544AbhKROLv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Nov 2021 09:11:51 -0500
Received: from localhost (localhost [127.0.0.1])
        by ofcsg2dn4.dwd.de (Postfix) with ESMTP id 4Hw1qj1dbzz3vgm
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 14:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dwd.de; h=
        content-type:content-type:mime-version:references:message-id
        :in-reply-to:subject:subject:from:from:date:date:received
        :received:received:received:received:received:received:received;
         s=dwd-csg20210107; t=1637244529; x=1638454130; bh=0aXjVUwp2MRjd
        FO8lFYKGzei3eTQXJFh1/lj7AUxfu8=; b=JC4ug2tBXBArbxzPKh+sTdlHDskDf
        2tXAJStl7Zs2beSxaiArd0Q4JDbtw5a5GmaTL06DRPs8SWlwW4Ie9uQTgE2iBr5e
        hYH/QForzJqzrLW4B5QAane6xTJ6lIOpt3+LUdiBnueUo/eFJRdt7WgqHR4dviaX
        UsfHi9vWAKKljYA/AKPtcUgu1pO2F8lgH5vifZLp5ORa99xyZoRO/+/ej+/TGbwe
        1FhA3zCt6meRFREb69JSxtZyJaVtT7dsO0RwmTR54TD4Ta+QKiV8cZUMoaDadFI+
        ceD6r2jTQFMByS87AEPC7A5HAEJ74DPflrRITjl0+sdO8jhPF/ZDDTHIg==
X-Virus-Scanned: by amavisd-new at csg.dwd.de
Received: from ofcsg2ctev2.dwd.de ([172.30.232.68])
        by localhost (ofcsg2dn4.dwd.de [172.30.232.27]) (amavisd-new, port 10024)
        with ESMTP id Q3CKhuu-KC5F for <stable@vger.kernel.org>;
        Thu, 18 Nov 2021 14:08:49 +0000 (UTC)
Received: from ofcsg2ctev2.dwd.de (unknown [127.0.0.1])
        by DDEI (Postfix) with SMTP id 5072B5E3DBC
        for <root@ofcsg2dn4.dwd.de>; Thu, 18 Nov 2021 14:08:49 +0000 (UTC)
Received: from ofcsg2ctev2.dwd.de (unknown [127.0.0.1])
        by DDEI (Postfix) with ESMTP id 179785E256B
        for <root@ofcsg2dn4.dwd.de>; Thu, 18 Nov 2021 14:08:34 +0000 (UTC)
X-DDEI-TLS-USAGE: Unused
Received: from ofcsgdbm.dwd.de (unknown [172.30.232.27])
        by ofcsg2ctev2.dwd.de (Postfix) with ESMTP
        for <root@ofcsg2dn4.dwd.de>; Thu, 18 Nov 2021 14:08:34 +0000 (UTC)
Received: from ofcsgdbm.dwd.de by localhost (Postfix XFORWARD proxy);
 Thu, 18 Nov 2021 14:08:33 -0000
Received: from ofcsg2dvf2.dwd.de (ofcsg2dvf2.dwd.de [172.30.232.11])
        by ofcsg2dn4.dwd.de (Postfix) with ESMTPS id 4Hw1qP5Wsyz3vR2;
        Thu, 18 Nov 2021 14:08:33 +0000 (UTC)
Received: from ofmailhub.dwd.de (ofmailhub.dwd.de [141.38.39.196])
        by ofcsg2dvf2.dwd.de  with ESMTP id 1AIE8Xew014827-1AIE8Xex014827;
        Thu, 18 Nov 2021 14:08:33 GMT
Received: from diagnostix.dwd.de (diagnostix.dwd.de [141.38.44.45])
        by ofmailhub.dwd.de (Postfix) with ESMTP id 29579E27A3;
        Thu, 18 Nov 2021 14:08:33 +0000 (UTC)
Date:   Thu, 18 Nov 2021 14:08:33 +0000 (GMT)
From:   Holger Kiehl <Holger.Kiehl@dwd.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 000/923] 5.15.3-rc3 review
In-Reply-To: <YZYLYlvdfi9ddToA@kroah.com>
Message-ID: <45eb66bb-818d-d1f-a78f-f7c7c1bcaa2@diagnostix.dwd.de>
References: <20211117101657.463560063@linuxfoundation.org> <413ef3-c782-be14-da3-da86ed14a210@diagnostix.dwd.de> <YZYLYlvdfi9ddToA@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-FE-Policy-ID: 2:2:1:SYSTEM
X-TMASE-Version: DDEI-5.1-8.6.1018-26536.007
X-TMASE-Result: 10--13.824200-10.000000
X-TMASE-MatchedRID: y/2oPz6gbviWfDtBOz4q26HggtOWAEvR69aS+7/zbj/mNRhvDVinv7BU
        pHHLYQpmSHSWZchqtCGn9WnUf4yXmVzhU0/oppo2uZBZOg7RfX9UIaneDj+GO2yIID37xcHKsb9
        HPmxftEn5yPaI4eFKR/kuGZQ5f5nDnEMCM6PzyYEK4MBRf7I7prw+GCqPUrbc+frbXg+Uc4Uq6L
        BhXC7ZgmUVI5FRUThefzUNu6btPNHt+DjkxhBU4jfu+RTlciXg4oSd18bdmwIyNJCVcSRuoA31l
        m1cxQaATToGGHMg/J5d+uVFnTtvxeVHGbcDbAq6/sToY2qzpx7dB/CxWTRRu/558CedkGIvqcoA
        hihTwviYPPIGKI9LSrTo9HU7Ngwfz5kNXzFS6ld3IU9XpIOZp2NJ1X7dZmox
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0
X-TMASE-INERTIA: 0-0;;;;
X-DDEI-PROCESSED-RESULT: Safe
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 18 Nov 2021, Greg Kroah-Hartman wrote:

> On Wed, Nov 17, 2021 at 08:25:12PM +0000, Holger Kiehl wrote:
> > Hello,
> > 
> > On Wed, 17 Nov 2021, Greg Kroah-Hartman wrote:
> > 
> > > This is the start of the stable review cycle for the 5.15.3 release.
> > > There are 923 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Fri, 19 Nov 2021 10:14:52 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.3-rc3.gz
> > > or in the git tree and branch at:
> > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > > and the diffstat can be found below.
> > > 
> > On a Deskmini X300 with a AMD APU 5700G this does not boot (rc1+rc2 also
> > do not boot). As Scott Bruce already noticed, if one removes
> > c3fc9d9e8f2dc518a8ce3c77f833a11b47865944 "x86: Fix __get_wchan() for
> > !STACKTRACE" it boots.
> 
> Now dropped, thanks.
> 
Thanks. Now 5.15.3-rc4 works fine!

Holger
