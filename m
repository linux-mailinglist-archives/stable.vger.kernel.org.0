Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9F22421C7A
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 04:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbhJECPe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 22:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbhJECPd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 22:15:33 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29770C061745;
        Mon,  4 Oct 2021 19:13:44 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id r43-20020a05683044ab00b0054716b40005so24037065otv.4;
        Mon, 04 Oct 2021 19:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5hMif7qMKdCwgcdncT1U6AF5cf0DlBL22tcbx1Mi6mE=;
        b=dRCvxYlAi9CpjE5z8EMY60n8KOlmylHuVJ3s3bygkoooT2McvSoY2luLg95XLVYLot
         Mk6caGBrzpggOD9ocVFGIngKEhqs4KFnJEjxVgxmvXL1q/XZ2baEF0cR7+M4zJ9LrUN6
         0tqzPtBdVePkNsmJuw9duPKIAQ0tETPd8p1jUoRzIve1BdyTsGoLa1HpHoAApbtDc6xc
         oab2I1jMhJZ2f3Ja5f0ek+abRP1yfIjdWMoxcxz3blea0iRf0A0iln+3Fi8XwspbGY7F
         4hyfeHtIl3y61oP9gZdBCiAPqupnDbpIrLpOTfmALe3PABJ3K8+zbMqftsowC0SGFEI7
         gfPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=5hMif7qMKdCwgcdncT1U6AF5cf0DlBL22tcbx1Mi6mE=;
        b=txOCSX/SieP2Ar0UaPzm9/L2A96xVAWcIzHE7DPAGO3i5hpCpT3BS3BtyBPwTNTRxB
         FvrztTP67VSYSGNGdXcQmWNK8mbw6+u78nIPwmt2Ts47jniQFTPnXIkTA1jsUhKebulJ
         JonZDbkef71nbXDVMlMImeLpi0hEkNceIgG3YYdWDkLtJBM4HXpq7TEpGBzKIKtiqq3T
         i6oHnsPhuc7whr5EdH/srjzXQj08/hlkc5vTwA0vaKKnANetmYsP3jvtV7XQSpKt1oEV
         Zf6R4qqaKzqc8/JsgjIR0wYX4dmWCWp8HlFwfmYi43UqDP/CbBWHxkkn9hgYJoUxw4KU
         mbjw==
X-Gm-Message-State: AOAM531SZ5pLyFg6TOvgZdqhn/vdtGoJ+PFViCnwUjQ2QClZPDgQSNzX
        SdkmwNaHDEHpX9VWL9wSqE0=
X-Google-Smtp-Source: ABdhPJzAdjqfyFedEDBjo8uu7mZAIOnvyx1D0Nvhgr3abUUFSxUXL7eS4K5jARmW0UvuNxUDm1jP+Q==
X-Received: by 2002:a05:6830:56d:: with SMTP id f13mr5649153otc.382.1633400023594;
        Mon, 04 Oct 2021 19:13:43 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 10sm3252645otw.53.2021.10.04.19.13.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 19:13:43 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 4 Oct 2021 19:13:41 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/57] 4.9.285-rc1 review
Message-ID: <20211005021341.GB1388923@roeck-us.net>
References: <20211004125028.940212411@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004125028.940212411@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 04, 2021 at 02:51:44PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.285 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 Oct 2021 12:50:17 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 394 pass: 394 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
