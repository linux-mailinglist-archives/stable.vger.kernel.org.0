Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3CC6CE555
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 16:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727715AbfJGOeO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 10:34:14 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40086 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbfJGOeO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 10:34:14 -0400
Received: by mail-pf1-f195.google.com with SMTP id x127so8779699pfb.7;
        Mon, 07 Oct 2019 07:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/JlUG/JC37ASFXVOEGLWFjO5CG+I+2T1GLGK2/eC31Q=;
        b=jyFHAyRKQJX/41bjJGhSJhmOteqJuA9vB4uHKru/ypb7X2RCKC0bJr60VtY+5IXrV5
         nsV+I4Pcv7KRlc6xBEyzUPwQaHu+dbOTKEbQw2P31DGGDMit3UfxwPhGEDyajAv7zhqc
         Z2yAdInsWyencynTwJO62K6s+099kixr5dqq29dOMZlDc+RAolPKlL0I2BbDHYf76iRN
         7ahGPGrDiNTvcyqqC5/b+uY8ozjzrf6wpJJA86wSl1YHczU3fEU/9GXwKUClwYP9ILLD
         JwBWCoZmRRi1SfzewU8bLEiWGET1pnFEyFX+5+4f40IIaiy2djxutpm4rvDO6Douema1
         waDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/JlUG/JC37ASFXVOEGLWFjO5CG+I+2T1GLGK2/eC31Q=;
        b=NF+Wl1Th7uD+EzcKWGTecq211DZWUh7LRGm8VQFQzDrYP0EJd7CxqJwR49r9yBWXQP
         rI10hT36OIWwHLcxW5sWwTF5DpZuXFNXzI6ZjjOqzWvK7Quq5R1OO7Xz5smbYU95A4h2
         v6jMNh6OfsKg0JHNA3dO/bnl5naVlLCpM+WyA0ArOab+pwiUdn0xQzFAUz5af0qPsrFa
         NJ8Zukv3MnY/bhg6RD0Un+/ovHXw+EeyyYly6bflhS9iXOcdRPJ0c43c3OZ656DkRJNR
         J6w5u5xlYGBX6KiJ2gTntJAlzW9FD8e6WdBNyyMZ9NOx/ruQ18OvGTBXt4Tpya7IQeXK
         nqDw==
X-Gm-Message-State: APjAAAVaDATxKTGbI08zzyFpTyboYyQPhUetNEVZr/6tTb7K3TSEN/HS
        +Z6q6AdpCeIKtjDJklwpCJRcNnPQ
X-Google-Smtp-Source: APXvYqyokcDaQH56U1aIL07HTI3wOUZyU9sDJrvs2qGxQokjbmLsKhxuqGiXVcuAXTIBGfw5dY1htA==
X-Received: by 2002:a63:d250:: with SMTP id t16mr2933443pgi.278.1570458853674;
        Mon, 07 Oct 2019 07:34:13 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k15sm3459765pgt.25.2019.10.07.07.34.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Oct 2019 07:34:13 -0700 (PDT)
Subject: Re: [PATCH 5.3 000/166] 5.3.5-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20191006171212.850660298@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <499f5926-a2f0-465b-9e28-466832e6f701@roeck-us.net>
Date:   Mon, 7 Oct 2019 07:34:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/6/19 10:19 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.3.5 release.
> There are 166 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 08 Oct 2019 05:07:10 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 158 pass: 158 fail: 0
Qemu test results:
	total: 391 pass: 391 fail: 0

Guenter
