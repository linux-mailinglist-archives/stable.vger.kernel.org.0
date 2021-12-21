Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5959847C989
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 00:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235864AbhLUXNA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Dec 2021 18:13:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234684AbhLUXNA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Dec 2021 18:13:00 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE08AC061574;
        Tue, 21 Dec 2021 15:12:59 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id v22-20020a9d4e96000000b005799790cf0bso440197otk.5;
        Tue, 21 Dec 2021 15:12:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VKB79YLzeCAZbyRHG8QHTuUnPBh8BoKZq8fcLwajQ60=;
        b=lBIjzMHGqhr2Ur1uBUTUWtE28wE7YIp4gTDphp+gPnwdWVCfMTxIIm9YasHEId6o3Z
         6Z6HBgU3wObgdT+hnz6cLzYy4SBcXvMRNyCUQKkDm90Iu7b9spLmWzKlioyCrPmG52uF
         qiYc/PVsWzxKFj2KDZYiQftwM/6/qWy4hF/Eps3TsnTq6dwZV9GGVohfUTWdgEG6oVUn
         gagYHoFtXmKTl3Q3yk8Ic8MgVZfn1IJl7Y3eaAUsxF/QWAVLC5jiGO5pFVgibPPTGlrN
         kbRlpYHjKnvkVIGyDFz/+RlC0baTunfWe6/0rlRduBeoytb9C+caHIgQfkw4VEKziDJd
         h1Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=VKB79YLzeCAZbyRHG8QHTuUnPBh8BoKZq8fcLwajQ60=;
        b=LjPve0JVO3tdstXmoY5BFc7rvPPorSEZWxcpb5On/uHoIRjHecXyt9QUttFMs/vcaQ
         XIfs9XbvrPgiQ0rHHurDlULfIGpqsLuLWtjrUU+nJktkytLWQPGT0YEnB/HRG/VBX2c8
         tnrc0Hk4OzLikjyE8L4WkTTYxuDaHTpWoWnBDuQ+jvx66v7+YAB/IJNp6tauSZiHGswy
         j0QfyKWbtB2bQIk6HUyDHUha1DbuIZfG6P/D+eBrNKHcr8fh3mbiiDTmKGtOSpaZJd2+
         DPfBsju3GP3u6QM1gC0rZHt88t2E2HBtTwPgcYGXYIp6d3Kz7HgIHa2tO06RRqQJ85Y/
         qz2A==
X-Gm-Message-State: AOAM532sE4yim406nseu5upQMgO5XL2rkOOC9/qWsXPrvHfmYK8rUF82
        dcOQ8p7SsaaEWRANdkTIz5Q=
X-Google-Smtp-Source: ABdhPJwqZahfofaGseA02lWeH+P//pM4uYLvxxa5C66hSQ3b3DzSDSzrG8gNavyzWcxYmoj25e5viQ==
X-Received: by 2002:a9d:19e8:: with SMTP id k95mr408333otk.12.1640128379229;
        Tue, 21 Dec 2021 15:12:59 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 4sm40364otl.26.2021.12.21.15.12.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 15:12:58 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 21 Dec 2021 15:12:57 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/56] 4.19.222-rc1 review
Message-ID: <20211221231257.GD2536230@roeck-us.net>
References: <20211220143023.451982183@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211220143023.451982183@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 20, 2021 at 03:33:53PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.222 release.
> There are 56 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Dec 2021 14:30:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 422 pass: 422 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
