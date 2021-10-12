Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7831C429B3F
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 04:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbhJLCC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 22:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhJLCCz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 22:02:55 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E844CC061570;
        Mon, 11 Oct 2021 19:00:54 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id z11so27088305oih.1;
        Mon, 11 Oct 2021 19:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Bghd1yI3izTnBi1pBrY21VoTlSFyGawzNDQeSE/tGSc=;
        b=kWwFxHsJkYnY9osxgHurfcubMEA1r1J/kjT0J97ZxsWJYh1crCl/Pu/LVNwrbEaId2
         AIZVA+QUcXFdOKjs88ofqc5Ljog/ea5u0nbZNT2ZjFmoNes/fYvjIHtHqNH4HrsfxALn
         DZHTbzvMJROj9lhV0aCAf45kq7LkLHJ1orUsEx1ujLKJh3Dti646o7wz/yZkGo9BdHRx
         VMrXlRSHAJszxnvCKkCpv+k4Mu1sfMRMOdg7BSsVEHvuI/quTTo3G3KTBPc9m8MgxKH9
         C0VrXsjEp009XcLY0bhAc/RVIeBzxbDe6XeU0gidL+0dKkww54VJLyJTwPcyrtg1Iq2u
         MMXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Bghd1yI3izTnBi1pBrY21VoTlSFyGawzNDQeSE/tGSc=;
        b=jpnMmAnBmd1mGZJkYITeiFDOmrFi890hAlZMjoszksdhTRiTSPlh5ApuN2SrNahQc0
         KlIKH9D5322FK/SXAsynUBuGgxY4HzSvp6pLG9ofJQdix3S5f6GDBC+YJy6hRVOBblv3
         aColW9w2Af4fT4FFSj4WhK/Slv417Xs6BqULan0QHqocRUyUg/FOlVSqnpRgdI0G0cTV
         b78mDB5T09enRE7wUWplIdjRbEZTOt8SG6BAVwJDe3giKJTTGTejftBAt42WtNe68uMF
         cQVpx3+fty+4jiMp6TCiq5Kkj4MNZn4PmUECR7QcKrUr8U0MwBWH7b4pzFVCl4sAjcKG
         yMYg==
X-Gm-Message-State: AOAM532vkQUDVmfYRdxTcqK7f2EpAuGp9OvIS9uNHBPbjsSZ1jq9MJ0D
        EHvavHIj8Puyf3mp3b+fs5I=
X-Google-Smtp-Source: ABdhPJxfSjQPDtZNx0/YQL/1aMNplgIAwgpx2AD0TUZmvg5q6iqj9Wv8O0t2ex986S+j3yoa2pOKdA==
X-Received: by 2002:a54:4f8f:: with SMTP id g15mr1649706oiy.169.1634004054044;
        Mon, 11 Oct 2021 19:00:54 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bf21sm1385336oib.4.2021.10.11.19.00.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 19:00:53 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 11 Oct 2021 19:00:52 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/52] 5.4.153-rc1 review
Message-ID: <20211012020052.GB2033605@roeck-us.net>
References: <20211011134503.715740503@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211011134503.715740503@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 11, 2021 at 03:45:29PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.153 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Oct 2021 13:44:51 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 155 fail: 2
Failed builds:
	powerpc:defconfig
	powerpc:allmodconfig
Qemu test results:
	total: 444 pass: 423 fail: 21
Failed tests:
	All pseries, powernv

Failures as already reported.

Guenter
