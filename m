Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFA20480BD9
	for <lists+stable@lfdr.de>; Tue, 28 Dec 2021 18:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236612AbhL1RH7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Dec 2021 12:07:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236599AbhL1RH7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Dec 2021 12:07:59 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E79AFC061574;
        Tue, 28 Dec 2021 09:07:58 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id w19-20020a056830061300b0058f1dd48932so24613761oti.11;
        Tue, 28 Dec 2021 09:07:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ybZPWyYt00abn3G1CpfroXfVp6h4A3rtqsrtum8vIao=;
        b=Gi8W0EpxHp6cVp2F+XEc/YVoWm9Yf6/u+jHSj7tr1MvoM79c3GZ2lWcc6U7+c1E2Ow
         2PNoG/2hNppGirVZCBBJcMhSPdw11P4xmyoDJEfu7fzX3hpoVKOqLLr0dBsVON81m+Mh
         21NdiU73q+HygJdDcb7t+7+KcYKtG/rOdVaXjAeFfoLMFLq+12/mcZCmy1xkWqWOd2nC
         P/PH+JiA0ayakMKBS8JYgDxjXWmuH5jvM7oTaTiNzjpTsRlwxfQcTKyawZBKtQomrcaH
         xke+lnmTm9KXH9fSf0r40E8Fo4f1xI9ERSCYRLTfptLRZastzBx5EayWheARtAqdZaDk
         sqHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=ybZPWyYt00abn3G1CpfroXfVp6h4A3rtqsrtum8vIao=;
        b=pHuhIr3ytBgnrHpemg2PAxMdfGDzErCdKyfbfpGg4t7b3slmgmI5EM4LQ204XmV8aU
         G+4gqsWRiNIaaT+gs1ns3PCcsZBvy1rX/3+gsAT1Y2BOy4aavNFJZ5JGOAEIUDOJ5iYb
         pYpQBHHbUXNmGW78LKzy9NzyPtkxlTA7mCbhQsOT1gQB5AQ7NOYJD/C/0Wpx+GzY5dTM
         OTJOX2sijgoY86oJgEMYCPUETWBjl5qJpFGIyv8AtPB5U+a1LONtmW5974mL+3wuH/VY
         02yzsNOmftCkYU0EX1MhPV/XEd6LLIHA+h0uU7AmvXtR4jZFaN0IgcqwA3ld7Iv+AgAV
         xPVQ==
X-Gm-Message-State: AOAM530yqyamMW315SWZTDUtuMB8/9gULkg0rjzbZKiQFBqVylH0Ab4t
        fpXrfwYXDIq1x+PqOt7Lw00=
X-Google-Smtp-Source: ABdhPJylE5buyRJZD3X230xZsT0g4iRxqBzsfi40Loyk4KqIZyL1RDa3JVaByt4uX+7twRev/FrojQ==
X-Received: by 2002:a9d:6058:: with SMTP id v24mr16002606otj.296.1640711278374;
        Tue, 28 Dec 2021 09:07:58 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a28sm3956243oiy.4.2021.12.28.09.07.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Dec 2021 09:07:58 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 28 Dec 2021 09:07:55 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 000/128] 5.15.12-rc1 review
Message-ID: <20211228170755.GG1225572@roeck-us.net>
References: <20211227151331.502501367@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 27, 2021 at 04:29:35PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.12 release.
> There are 128 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Dec 2021 15:13:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 480 pass: 480 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
