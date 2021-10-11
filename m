Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F852428AED
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 12:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235913AbhJKKoG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 06:44:06 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:57300 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235901AbhJKKoF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 06:44:05 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1633948925; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=yQEeqerf7Ei3Xw3vldPBO/PbPsJ5X9qa47bE01NgrCM=; b=gqGoWw/prRx1zi9V6fhpXLHewP2VQKfNxf0KNMX2pnzjWuiryWNwKNm8FHBckWE+NScq2Mtw
 FUp11iguZeLj1wlzGo+wZJ8Ew/PRpK/tdNciYh1LleK6Gho9mdHMsJdqcFb0e2XPzT8ZsxYb
 9WSX2urFfgd1cNoh2WeoG14GIcQ=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 616414f522fe3a98e5846f62 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 11 Oct 2021 10:41:57
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7A5E8C4360C; Mon, 11 Oct 2021 10:41:56 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from tynnyri.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8BD32C4338F;
        Mon, 11 Oct 2021 10:41:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 8BD32C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Pali =?utf-8?Q?Roh=C3=A1r?= <pali@kernel.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: Drivers for Qualcomm wifi chips (ath*k) and security issues
References: <20210823140844.q3kx6ruedho7jen5@pali>
        <YSPxO+VGnSopgn5G@kroah.com>
Date:   Mon, 11 Oct 2021 13:41:50 +0300
In-Reply-To: <YSPxO+VGnSopgn5G@kroah.com> (Greg KH's message of "Mon, 23 Aug
        2021 21:04:27 +0200")
Message-ID: <87czob3ksx.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> writes:

> On Mon, Aug 23, 2021 at 04:08:44PM +0200, Pali Roh=C3=A1r wrote:
>> Hello Sasha and Greg!
>>=20
>> Last week I sent request for backporting ath9k wifi fixes for security
>> issue CVE-2020-3702 into stable LTS kernels because Qualcomm/maintainers
>> did not it for more months... details are in email:
>> https://lore.kernel.org/stable/20210818084859.vcs4vs3yd6zetmyt@pali/t/#u
>>=20
>> And now I got reports that in stable LTS kernels (4.14, 4.19) are
>> missing also other fixes for other Qualcomm wifi security issues,
>> covered by FragAttacks codename: CVE-2020-26145 CVE-2020-26139
>> CVE-2020-26141
>
> Then someone needs to provide us backports if they care about these
> very old kernels and these issues.  Just like any other driver subsystem
> where patches are not able to be easily backported.
>
> Or just use a newer kernel, that's almost always a better idea.

Sorry for the delay in my answer. But like Greg said, use of a newer
kernel is the best option. I don't have the bandwith to maintain ath[1]
drivers in stable releases, but I do try to make sure bugfixes have a
Fixes tag when approriate and I do add cc stable whenever people ask me
to. That's about it from stable releases point of view, my focus is on
Linus' releases.

Help with the stable releases is very welcome.

[1] ath9k, ath10k, ath11k etc

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
