Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22A7B46275A
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236597AbhK2XDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 18:03:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236842AbhK2XBQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 18:01:16 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F11C08ECBD
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 12:12:04 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id d9so18521787wrw.4
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 12:12:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorfullife-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=cUOauZjBYytaE6Fy1uvioA+73YerQcwMi6L2R1agF9E=;
        b=aGQ1lhUL1f1I1z1hZYvQ0EOe6eXoVjp5VL/N5y2lpefeQSbm8mAvy4PHd51mVer2lf
         sOhQhC8sM2SgC1oukr5ifVPTdz//0WNqoSbxjUBeo5xdUK+XMhjkG7ZvC5qQL9FEEbyU
         MYB3g7wV62YX/lqNhligNVaK+rAuAfEikDLszuHQeD32LTPIN+JzFVKqr8xmiDT3yMVN
         ySUR19ye6Shez4tG4XzgFUBUWJtcm39IjBCMgIFPlqAjyBE9mdptxyG2mPxVYqCUv4S4
         E0PmQNV3GyiYMBTSm0vu+rOqzAQbeufhq9tbNsIhJmUMtWgW0pBqC9LDSSHgDOKkjt6I
         Z+1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cUOauZjBYytaE6Fy1uvioA+73YerQcwMi6L2R1agF9E=;
        b=bmxqEsh4HAVjZmpItGNuJhHHW89ggAcDuvp4Mgd3uDIxKIRZhVknWFit3uuoFuQdVs
         bJVj/1q1NnF364hHFLknc0zF5BmCJLoZpM+oowA6dYWocl3xY6ihXCJQ6roe4Xo8nYzt
         jsdGmSzvGb90jiNetHAJc/Y6g238+nvA/a1ft9JrlD32I9JEg/FcVO/o2nrNrgZbkrnY
         uf4Ge22jI74DOXg/xQuTPIE3CXDRdTLIovjTDxU8J90Huf9Kt1qj2hgVlwjHiUpq04B2
         UyhNt9dKzBKLX5E3v33+FMU3fQXBdoAcDdpcQFgEe2tcPrM9DI9X6AoMBVRf9k2e58XD
         4TMA==
X-Gm-Message-State: AOAM531P0+BIe2fAtZF/HiAOz+Ixt6U6HwtukLInnO/H8Xpir6PmiOZ2
        4H6AttOo1UrAhvhAHeHMLaCeHQ==
X-Google-Smtp-Source: ABdhPJwDvOuWo2pXaPN5o9WWEHXGvUwdDSqUXSfIeLr4mLhK2+qoQppjMUb2CYcCLO2wX3vZ657+6g==
X-Received: by 2002:a5d:64af:: with SMTP id m15mr37682811wrp.267.1638216722971;
        Mon, 29 Nov 2021 12:12:02 -0800 (PST)
Received: from ?IPV6:2003:d9:9707:9c00:6c18:86fe:ce95:31d? (p200300d997079c006c1886fece95031d.dip0.t-ipconnect.de. [2003:d9:9707:9c00:6c18:86fe:ce95:31d])
        by smtp.googlemail.com with ESMTPSA id n32sm377908wms.1.2021.11.29.12.12.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Nov 2021 12:12:02 -0800 (PST)
Message-ID: <2b9bf5cd-7e65-a532-afbf-9f94c3ebb45c@colorfullife.com>
Date:   Mon, 29 Nov 2021 21:12:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] shm: extend forced shm destroy to support objects from
 several IPC nses
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>,
        Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Cc:     stable@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Andrei Vagin <avagin@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Vasily Averin <vvs@virtuozzo.com>
References: <163758370064179@kroah.com>
 <20211129164300.789517-1-alexander.mikhalitsyn@virtuozzo.com>
 <YaUNb9NyKVio+bQ6@kroah.com>
From:   Manfred Spraul <manfred@colorfullife.com>
In-Reply-To: <YaUNb9NyKVio+bQ6@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello together,

On 11/29/21 18:27, Greg KH wrote:
> On Mon, Nov 29, 2021 at 07:43:00PM +0300, Alexander Mikhalitsyn wrote:
>> For 4.4.y:
>>
>> Upstream commit 85b6d24646e4 ("shm: extend forced shm destroy to support objects from several IPC nses")
> We need versions of this for 4.9.y, 4.14.y, and 4.19.y before I can take
> this for 4.4.y.

We have tried to be too clever: I had start top down, Alexander bottom 
up, ...


@Alexander: I've sent 4.19.y around an hour ago. Could you create the 
change for 4.9. and 4.14?


For the 4.4.y:

Tested: With the patch applied the crash is resolved, no observed 
regressions.

--

     Manfred

