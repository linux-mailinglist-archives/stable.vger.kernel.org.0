Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA2ED35C71
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 14:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbfFEMT5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jun 2019 08:19:57 -0400
Received: from mx08-00252a01.pphosted.com ([91.207.212.211]:57548 "EHLO
        mx08-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727172AbfFEMT4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jun 2019 08:19:56 -0400
X-Greylist: delayed 1053 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Jun 2019 08:19:54 EDT
Received: from pps.filterd (m0102629.ppops.net [127.0.0.1])
        by mx08-00252a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x55Bucxd003514
        for <stable@vger.kernel.org>; Wed, 5 Jun 2019 13:02:20 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raspberrypi.org; h=subject :
 references : to : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp;
 bh=LY3cobxunjCRtR/HKPXZMJ4XjOimaM7jPQHIxiqCI4Q=;
 b=djRzysk8ZwuSv+CZGv6PfgRrI852BXoc5iYQQJbrPXynY10FUIoqiECKr1WkxVY06OPH
 mfx69PieO9NyqsAe9k8A8/qdN4DFRNz3jvhY4K3cYXunsHMgaZ+vsZ/fjX47Nz8iM1jt
 TakgHrgB6v/DhExJa0ALHNVf3MDO4jKotHxtJmXTMYb1WDRVXlJnC++y490/xKGfLPW+
 PhEmKOriP6kqZDdKXTc9rTNUGLGIRqPYdEHbsgqLlMBW8cWmWM829BPqd+cgYz3ctBLH
 4rgrBB2iyco2RRZub6zk2d37oRdoeCh3ASdoPkyAe4NudNEf7b82HpyA5hwGc3n16Hka 9A== 
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        by mx08-00252a01.pphosted.com with ESMTP id 2suduj2303-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <stable@vger.kernel.org>; Wed, 05 Jun 2019 13:02:20 +0100
Received: by mail-wr1-f72.google.com with SMTP id b19so11442937wrh.17
        for <stable@vger.kernel.org>; Wed, 05 Jun 2019 05:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=raspberrypi.org; s=google;
        h=subject:references:to:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=LY3cobxunjCRtR/HKPXZMJ4XjOimaM7jPQHIxiqCI4Q=;
        b=O8MPmCB+a5DpWcyg1ehjSm8D0KaN7T/oxcVHUKaOOFwHa3oJnMfP7KSLTRef+K+uy7
         X62dzihDgO33vt9MWlGhJNhz+02icbPsz5m5a66C1zh9m4ia7IjhW/Mz9zgoEH9Wb0IS
         I8sJqXSDK6aZZ860c+WuHk6piEfnBzMMrD2ET14hbf5caUnh0X7lGGeuBfaXMAsNXesT
         GGbx6R+4JvrQRCgB0nNlA3aQGNGt0BqTSvnUrILYi0p8zajGvxtD04ODaUNYx/L041lK
         1awYVldsClEdvC6lUMjcCi400YRrZ+5HUmB+tGbQotm0yNPC64rltkbUiiJCU/VZZWWE
         LGHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:references:to:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LY3cobxunjCRtR/HKPXZMJ4XjOimaM7jPQHIxiqCI4Q=;
        b=tbhG8fFTkHyA5Rmej8EO53mkcqZSPb8trvkPWrh1nd6BQZr+Nek3BNjYmaxemnucjV
         6lKEzheMfWahnoLNDtNqYHUUpLG4y/4G51Rfw35hWu7UnvEr3tC69/XPL1uJVjXtfSrv
         5+LlBEobR217pcLAhLM/7BBGqNAkkTYuG/wdoKld2J+VASqxWvkUGSiy8f3s5MIumixQ
         ctDuktE/fMjBYpN/iGQx/8ss7dIhXlmRHfmkAOgTraIr+/thIsh+g4LjAc/CjMVUJzTk
         uAgXwC6tiKE8gXDospaGKbp7D0VaWWBW07PB5VHbNM6//wXCtWvHtpIsczqsR3Z6jLMS
         6STw==
X-Gm-Message-State: APjAAAWkR5BKJ3yiZxSH8ZcogYZRNAWkFhWimYXLO9uYOK3HDbRjnqkO
        OmOYgr+Pz5GsNYZw2P760/wZrhpb43mF7kWtvaGeMI47UWzpNyLp4ViNGm9iqW9yPOFCuC5KCiH
        gJtbxUoDCuWlpVMST
X-Received: by 2002:a1c:2e09:: with SMTP id u9mr12257339wmu.137.1559736139315;
        Wed, 05 Jun 2019 05:02:19 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzDjh6B+/A62T7WlwCF1YWNeQ6Rqe07iU25aug94Y2yMGeo6li++8v8cmQXhzCxeW6APflj5g==
X-Received: by 2002:a1c:2e09:: with SMTP id u9mr12257263wmu.137.1559736138380;
        Wed, 05 Jun 2019 05:02:18 -0700 (PDT)
Received: from ?IPv6:2a00:1098:3142:14:2cbd:20df:89bf:def2? ([2a00:1098:3142:14:2cbd:20df:89bf:def2])
        by smtp.gmail.com with ESMTPSA id o126sm4578780wmo.31.2019.06.05.05.02.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jun 2019 05:02:17 -0700 (PDT)
Subject: Dynamic overlay failure in 4.19 & 4.20
References: <45e99a24-efb9-5473-2e57-14411537dc9f@raspberrypi.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
From:   Phil Elwell <phil@raspberrypi.org>
X-Forwarded-Message-Id: <45e99a24-efb9-5473-2e57-14411537dc9f@raspberrypi.org>
Message-ID: <2da582d1-11eb-3680-33f2-3a5c139613a8@raspberrypi.org>
Date:   Wed, 5 Jun 2019 13:02:18 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <45e99a24-efb9-5473-2e57-14411537dc9f@raspberrypi.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-05_07:,,
 signatures=0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I think patch f96278810150 ("of: overlay: set node fields from properties when add new overlay node")
should be back-ported to 4.19, for the reasons outlined below (briefly: without it, overlay fragments
that define phandles will appear to merged successfully, but they do so without those phandles, causing
any references to them to break).

Frank Rowand agrees that a back-port is necessary. I can verify that it solves the issue of the missing
phandles, and as far as I know it doesn't cause any regressions. However, the code in question isn't
really used in mainline kernels, so I understand if you prefer to leave things as they stand now rather
than risk further breaking a stable kernel.

Thanks,

Phil Elwell, Raspberry Pi


-------- Forwarded Message --------
Subject: Re: Dynamic overlay failure in 4.19 & 4.20
Date: Tue, 4 Jun 2019 11:20:43 -0700
From: Frank Rowand <frowand.list@gmail.com>
To: Phil Elwell <phil@raspberrypi.org>, Rob Herring <robh+dt@kernel.org>, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>

Hi Phil,

On 6/4/19 5:15 AM, Phil Elwell wrote:
> Hi,
> 
> In the downstream Raspberry Pi kernel we are using configfs to apply overlays at
> runtime, using a patchset from Pantelis that hasn't been accepted upstream yet.
> Apart from the occasional need to adapt to upstream changes, this has been working
> well for us.
> 
> A Raspberry Pi user recently noticed that this mechanism was failing for an overlay in
> 4.19. Although the overlay appeared to be applied successfully, pinctrl was reporting
> that one of the two fragments contained an invalid phandle, and an examination of the
> live DT agreed - the target of the reference, which was in the other fragment, was
> missing the phandle property.
> 
> 5.0 added two patches - [1] to stop blindly copying properties from the overlay fragments
> into the live tree, and [2] to explicitly copy across the name and phandle properties.
> These two commits should be treated as a pair; the former requires the properties that
> are legitimately defined by an overlay to be added via a changeset, but this mechanism
> deliberately skips the name and phandle; the latter addresses this shortcoming. However,
> [1] was back-ported to 4.19 and 4.20 but [2] wasn't, hence the problem.

I have relied upon Greg's statement that he would handle the stable kernels, and that
the process of doing so would not impact (or would minimally impact) maintainers.  If
I think something should go into stable, I will tag it as such, but otherwise I ignore
the stable branches.  For overlay related code specifically, my base standard is that
overlay support is an under development, not yet ready for prime time feature and thus
I do not tag my overlay patches for stable.

Your research and analysis above sound like there are on target (thanks for providing
the clear and detailed explanation!), so if you want the stable branches to work for
overlays (out of tree, as you mentioned) I would suggest you email Greg, asking that
the second patch be added to the stable branches.  Since the two patches you pointed
out are put of a larger series, you might also want to check which of the other
patches in that series were included in stable or left out from stable.  My suggestion
that you request Greg add the second patch continues to rely on the concept that
stable does not add to my workload, so I have not carefully analyzed whether adding
the patch actually is the correct and full fix, but instead am relying on your good
judgment that it is.

To give you some context on the patch series, I started with 144552c78692 ("of: overlay:
add tests to validate kfrees from overlay removal") due to my concerns with how
memory is allocated and freed for overlays.  The added tests exposed issues, and
the rest of the patches in the series were dealing with the issues that were
exposed.

You can see the full series (with maybe an extra patch or so) with
git log --oneline 144552c78692^..eeb07c573ec3


> The effect can be seen in the "overlay" overlay in the unittest data. Although the
> overlay appears to apply correctly, the hvac-large-1 node is lacking the phandle it
> should have as a result of the hvac_2 label, and that leaves the hvac-provider property
> of ride@200 with an unresolved phandle.
> 
> The obvious fix is to also back-port [2] to 4.19, but that leaves open the question of
> whether either the overlay application mechanism or the unit test framework should have
> detected the missing phandle.

Yes, unittest showed the missing phandle, as you described in the /proc view of
overlay.dts above.  That portion of unittest depends on someone looking at the
result of what is in /proc/device-tree and is not automated and is not documented.
I intend to automate that check someday, but the task is still languishing on my
todo list.

> 
> Phil
> 
> [1] 8814dc46bd9e ("of: overlay: do not duplicate properties from overlay for new nodes")
> [2] f96278810150 ("of: overlay: set node fields from properties when add new overlay node")
> 

