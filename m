Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20E6D44DF71
	for <lists+stable@lfdr.de>; Fri, 12 Nov 2021 01:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234605AbhKLBAx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 20:00:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234146AbhKLBAx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Nov 2021 20:00:53 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F549C061766;
        Thu, 11 Nov 2021 16:58:03 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id be32so14800667oib.11;
        Thu, 11 Nov 2021 16:58:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OHoTLK449SpHlrkAKKKhdipzEpWjBjJsD4sPzyNaGjc=;
        b=nuoOF8D9mL8ZzZ7CUZdCqV62OG3rtpE+vN2yfPkNtKuiMLd0UNgjbcW4Iu1AmeguLO
         kD+0XovOBreZ0DbZmlFtjbMl5RljnH99C8y9AUz5rNiT5w6tH8Eph3pMXtPxT73kdV94
         OOYxecrIP8+d2I1a/v53vd2isQTs0MZhwLcWN3H/jYqwOCi9VTOrezVMRD7c710NmyED
         nZLai/UU66SjiN0POsiHb6KGr24jnvZOKA3uXo2lAlXUgvjC8U6x+bCYi8Wlu85bkS/r
         iJC+m94jrHf73QXqvtGqBN8ptRl6kTQEXmgnSQgLqNVyc8bNbdOcRegTY6S6X79m40Dv
         p0YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=OHoTLK449SpHlrkAKKKhdipzEpWjBjJsD4sPzyNaGjc=;
        b=mXXJB7Q0G6xXlK4SbiOY3ZiATQHzJ1q4FeGTHG2/BeykQcFtg7FimpzGlKtlsp5Y4F
         WBxut0dHC2ZjZmxJhrsMQv+iCl4vwUxLr33VchEa8WfbSW2z/b9V8MZy8V399PazCATH
         ExX0g5Ir9AoJ/amYCS6IMeclq8GHdZBdh89Gk+jgeMRKlZUvI8dwJlKXIi6qeqdg3d2e
         OFrY3cCt6Rf84oACmfe5vPH1Gnm/vtoXemPjQO12fpGAnL/YF23d0d5R2zojQobOfUd2
         gdcAYpyjSAgFROI8DvjTgttMSSBJ1+PDA5ZAPM1jkQH+tHpZtzbHbO5ZdAHaPoeYf+Dd
         H+hQ==
X-Gm-Message-State: AOAM532UN1o1rzCyohJ0RdL23IH8DWWmsvvYXFFtnHlHUObMEN6O5Vfh
        BXRqRe7fCHm9KTzOpxU3WPM=
X-Google-Smtp-Source: ABdhPJzE2Uz3W05bAzpPc7cViacV6sid8xx62uqifGuEiM/CuoJD6vm99n6yWKm72t9yAMYeigRroQ==
X-Received: by 2002:a05:6808:1a01:: with SMTP id bk1mr9889982oib.46.1636678682598;
        Thu, 11 Nov 2021 16:58:02 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w71sm993704oiw.6.2021.11.11.16.58.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 16:58:02 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 11 Nov 2021 16:58:00 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/22] 4.9.290-rc1 review
Message-ID: <20211112005800.GB2453414@roeck-us.net>
References: <20211110182001.579561273@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211110182001.579561273@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 10, 2021 at 07:43:07PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.290 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 396 pass: 396 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
