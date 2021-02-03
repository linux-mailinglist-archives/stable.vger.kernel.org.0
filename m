Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3CC330E452
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 21:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbhBCUy1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 15:54:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232301AbhBCUnl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Feb 2021 15:43:41 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A11F5C0613ED;
        Wed,  3 Feb 2021 12:43:00 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id v1so1170069ott.10;
        Wed, 03 Feb 2021 12:43:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CKYCi88+0Ag2BbFUnVAQa60RdS5EtzlRXfYMJ1ftoRk=;
        b=TcvtTjSnVxL5YEU0OJuaeEMtBaupV1ygNLKqOXo2J6bRxoVOneIzfSSHghA0Tad7dt
         VIbaspvM2mVhDF/f7ZlSLTQBy7o4XhZqd0B75INemYH6XQ0WGq02V33cOdgiq0KX5kyo
         gQ/MKZddzgQDIo8npVgYk3iQOD/h55vtMRM/KrOwDVJOxtp0nGCdwIC29CIpUxwQ7nxe
         zcC35GAy473tu79EiXKlpoFiqJSNMfHVHlEoGqnRAD25hajIq7cvG3g/IkFaWeulAkkS
         rB7uJj1DpfScvzw5GiXLUzl3k4NNJ0Vzj03dmS/XMFNVBfM/xSFFPpQBZ8BHXsLflD67
         yU/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=CKYCi88+0Ag2BbFUnVAQa60RdS5EtzlRXfYMJ1ftoRk=;
        b=h+mSfj+pAc9XmMGEAqVqYEF6IG5l+CRHwUVKjZoQbHmTD5qojakd4bbl2gTnVa/Koy
         LNYtGoEzxSCAZxMBmaUxCKwsZ26u4EO7TPvg/AU88MUDZGvHUp9aaFAkkbzyyneMOHzm
         Lbj+ifXNxxXNomMcVJbLKnTFDjJguxKx+ZxLSleD3/t17vt7lZWCzSJzargoUdo2kZZQ
         d4TjU666pCSbx1E+voZ1Kq2bnsIDatV3QtVclwiXLjEd8s7uFW8Ab2xiDMKX16BtPlBA
         EBm6u80Vt+S6rAC1NNvor9s2vaARO78m6qRSjSZ1G6gZiCCSLo+ZsDabvB2nLjt3NW7b
         fPGg==
X-Gm-Message-State: AOAM530FqNiWt6kh76HnA68GGWEkYx+CqKc5y8pnKnJi5TLmDSyzOVbZ
        pg//NvIf5DdjLoO8KULkjvf1mW6kt1Y=
X-Google-Smtp-Source: ABdhPJzXhpLgFu8fdikvHg98JvsK4D3dG6xIC5FOJRSpG1xdca/K0u1XoUQyn6+0SOzIqyAh/OnGYA==
X-Received: by 2002:a9d:6e98:: with SMTP id a24mr3286387otr.351.1612384980130;
        Wed, 03 Feb 2021 12:43:00 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c26sm657585otu.48.2021.02.03.12.42.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 03 Feb 2021 12:42:59 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 3 Feb 2021 12:42:58 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/142] 5.10.13-rc1 review
Message-ID: <20210203204258.GF106766@roeck-us.net>
References: <20210202132957.692094111@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 02, 2021 at 02:36:03PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.13 release.
> There are 142 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Feb 2021 13:29:33 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 427 pass: 427 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
