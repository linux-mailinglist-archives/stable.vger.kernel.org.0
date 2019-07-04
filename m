Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B81605F24B
	for <lists+stable@lfdr.de>; Thu,  4 Jul 2019 07:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbfGDF32 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jul 2019 01:29:28 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45421 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbfGDF32 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Jul 2019 01:29:28 -0400
Received: by mail-pg1-f195.google.com with SMTP id o13so2324493pgp.12;
        Wed, 03 Jul 2019 22:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3ZTQlkNjY3aX3rY5t8DCioMQNq79qjXO34dHqx3Xbto=;
        b=BQkc2/h7Ui5Jir7RJ9QhFClAdzZ0czbENEfw4tubpWvdvnt9l5BKB27jGpXXjb3ZIb
         ZI3qbgWZ36aQnxe8xdXRR60jL8FZ08u1+lSAsrghPQl/kgWQYN47xwVbqsFNIQ0texOF
         mrGLytZWWtkzVE1D9z29qgaCJfO+FBIRxN+obBtz8eAJ635vRtJhAIwlgFDAVMiuuDdE
         ZhBypcSw3HkjD+S4yqJjTSEa4l4ksula/V87jX8SvdilGzgsnp+9HAF+93BL5jFoL63h
         NehkOD4/kBDflkndXBV2g8kzDs4nmz1nZFZZSKtGgF5RlMrjRPDMEcwnDkMaS0O5Ip70
         kpjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3ZTQlkNjY3aX3rY5t8DCioMQNq79qjXO34dHqx3Xbto=;
        b=jNwW2GneN0cBkxq2g1+VRPMSgn8Iyj3i9YxDnf8RNjuh9fR3JscNeDa68fpH9jAu+T
         WfTRfmLuzvatDEBmcHBvl/iszU5QPCgK7gloo/pecYot5DaDOixOMs07thrIzW/Fu7dj
         VIKGY+4syWyXRrai8QzN2aLoHp/P6uHjFctgLpk0t+sDZwCpHDHCbOkfwTedFxNEumLI
         AhT0zN9GpeWNVww5pA9HFzBklpCAmMDGYOSm8M/EvAFHFhFExTvZeZLO/Pjo3Gi4xKM6
         91La/VsK+6y06npNed5XdXzvupOTA7w8HLS8xXWxMOW4fU51ThbOfrcvHgtrFNIqurFv
         Mr3w==
X-Gm-Message-State: APjAAAWoiwluuh0VjoitnCTdxioUptSGrgeI26rmIZ6uW9VgEysmAFQZ
        9zkLZIFgKACoHzDBSDoYjxx47Fh7
X-Google-Smtp-Source: APXvYqzynENxU0AQiZ5wIDErF8tnhltdVB7CsscVE81bmWA75neNIlzvPhpNm4BzdVU31AWcMUZ0eQ==
X-Received: by 2002:a63:f150:: with SMTP id o16mr41546998pgk.105.1562218167990;
        Wed, 03 Jul 2019 22:29:27 -0700 (PDT)
Received: from bharath12345-Inspiron-5559 ([103.110.42.34])
        by smtp.gmail.com with ESMTPSA id q63sm6371822pfb.81.2019.07.03.22.29.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 22:29:27 -0700 (PDT)
Date:   Thu, 4 Jul 2019 10:59:18 +0530
From:   Bharath Vedartham <linux.bhar@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/72] 4.19.57-stable review
Message-ID: <20190704052918.GC16449@bharath12345-Inspiron-5559>
References: <20190702080124.564652899@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190702080124.564652899@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tested and booted in my x86 system. No regressions.
