Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5894817D8
	for <lists+stable@lfdr.de>; Thu, 30 Dec 2021 01:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233574AbhL3AGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Dec 2021 19:06:55 -0500
Received: from mout.gmx.net ([212.227.17.20]:38453 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230083AbhL3AGy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Dec 2021 19:06:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1640822813;
        bh=UCEKqMCBwe/ZBUsIWPWma+7acAL2Vg9ytcL8yVbR4q0=;
        h=X-UI-Sender-Class:Date:To:From:Subject;
        b=Puz1IB/CvEwgHDR1WF5gKmxT4PlWEE4YwT4DXfAmjX+XdKRzmu2loO9Jbiik0V7V6
         etlLm5isgKSQ3IKn/XgFgOwgTflvQSj77HOrvpLkeolAICdpKr3tFB3SGYs427nlSF
         2G2hLYjTwJKgevZUpTTP/hagBBmTuFD4JGX988Og=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MSKu0-1mrc6m1wV6-00Sbut; Thu, 30
 Dec 2021 01:06:53 +0100
Message-ID: <8b9f45d8-768a-d76d-3de1-f3998dd77e41@gmx.com>
Date:   Thu, 30 Dec 2021 08:06:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Content-Language: en-US
To:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        stable <stable@vger.kernel.org>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Should write-time tree-checker backported to v5.10?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:pdcFcJDAsTEEnLlgH0UCqWM7n3XS65B3cZN2chq1+qvvUe2N9rH
 aBSqsVfnNeOkBJlZ/kstPvXJS9ssDJclmg5uBsaXGTYht9yEZdrWKp+nDyjT9k7XwB/62J8
 LHesKURrxS7cKmKppWwPXkmutrYdxpryGvWXaictnQRz9bkHBsAoylKVaZTJoUMXffsqRyX
 rsH7hR1ZSlwGs4epfE6PQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:OK8cMexUkyY=:5zTvVt78oQl8cjGSRHraEy
 GYVg1CHR0EX3Ex4dlQA1FRXvF2WADyFrHDexs1NkaXWEKwCX2y9ps55wkcl3dov57xfI3+1gB
 jyB2rd0WFR7pfYHgD0bB/tvyIahhXDJeVdVLLdQrcQEJa6IWBP1GDiqCRVhwlX7ZpybsqsNUp
 WcEscvD4IbTeI7vC7m0OYHytQYTkDIztdbR2ZHjtSl+Lzvy4D5pL9nUvlmEykzs24/+8Mnu3V
 hU8RvBpjd0CQeVzWhLq/p7qOTsUJNf1TWMRk88Sd9muucUSgEE5B3Pz3ISQpll8Mug96qxVLJ
 zLQc8VZC0QBCwnNWHBf2gT8JIx4vWPA0cigFBrih3XErraoec9eofyGWYU94RQjWNp1OqEp4E
 ZZVGToUJjYfGm/zOZaNVXNvpSCLNwF0GOybg4Fnd8zeZ5bEhZQa9n6ziFFV6FTpwO6NBUILQW
 68FCVnPGWixWp2GPqs6rrV24yBihFoTEyCe3H2PJaEFT2HNOa8gMeYy+pLcKX0MOCVcqTMqIV
 ojN/WZuc7Ya+aE2sg9i6pkrithvyI8i7UdZ+6uhZIZ1q+eqAYJMj3DBPfxcroZ52QWSh7Jhyv
 IiBNyefKb6LPbhlRRhfOZZapF4rGP0QqosGgI7X1b3TBQYmQ5213WBHaOYaCzTLiuG86zfsI5
 VehXDC8efP8MD/KBr4zLUgQxHhQ/RtlBEeU+Epf66akhhsEvwKtUSLkxjE7b3n4aHaRJQNi8p
 bMLHxeanSmFQQVStnVn1TVBnelLxuA0gSx+MwC++N8zveOFmm8Q+BdN2mYmDsNU7miDB2DjQH
 O23INkeXijO90NEEpL+vxlt/gfkvKMbFRJeL5a24c2JG46BVYtsdCCNbpun8+DdYedXo3B8Wj
 bWOhLUVu7xhYCLf0K1estnxe2z8orbylltI6gQzDYwNmLpfdi3hg+lddLhv3k1HChJFeFS3LS
 +2cQCr6K9Gdb4Dd0Tj/rc40PwqWz5ePL/xnjKCp14scoGjnijnxaHm1OOSrCZNZ3brwHDNzfQ
 g6+UpO1Hebbh9RrcP5dzhy3rigl6pHwcJUNYqQvmCWoWkrHyLHme744aOh4A/xJakmi0cjV7y
 vZu/OREsJZwndQ=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Since v5.10 is an LTS release, I'm wondering should we backport write
time tree-checker feature to v5.10?

There are already some reports of runtime memory bitflip get written to
disk and causing problems.

Unfortunately write-time tree-checker is only introduced in v5.11, one
version late.

Considering how many bitflips write-time tree-checker has caught (and
prevented corrupted data reaching disk), I think it's definitely worthy
to backport it to an LTS kernel.

Or is there any special requirement for LTS kernel to reject certain
features?

Thanks,
Qu
