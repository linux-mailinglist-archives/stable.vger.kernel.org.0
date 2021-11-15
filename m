Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0565451670
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 22:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242093AbhKOVY4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 16:24:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353369AbhKOUzl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 15:55:41 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6BAEC0432ED;
        Mon, 15 Nov 2021 12:47:47 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id np6-20020a17090b4c4600b001a90b011e06so864251pjb.5;
        Mon, 15 Nov 2021 12:47:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=37iPORGZWTcbPqrckEZeI9K5Eg70KvF8yptSAflO4Uw=;
        b=RXgsN+aOmT0tvd3MDXT6gExcbkqyWM5NKd/5m3diH8mIMI9/WsCSqcb0y3AlsaU/fe
         gJXFPIH8n0E3OZ0SrNXjjfVOu1D+z+VH7lIlKVYihp0qMAgCKB7iXol4vds9hWF2hv5P
         E0+E1x37UO63H31p+Zhm6imdXbJQ0WN7qA0XfTcqHjAETNkXFTVv5mNZUgqWNwv8UAAe
         fpvh45SscJE22UUN8Ao0deyYMpASeupP4MsdYDKzswUaVG0FpP5poMgvcmWYTpE7UVQt
         XIBmXZpqYmlgcVYYLMpWCH1SZjyxteY3aPuEXMlBb8gebjC+CmST318B1cFcJhsONIN6
         u1iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=37iPORGZWTcbPqrckEZeI9K5Eg70KvF8yptSAflO4Uw=;
        b=RY84vFThyMs/brBbuhN5QzVC8BAjAXs+407ARSpqjHS0Bzlwy7QIxc7YyAH5sqabPt
         6QHvllZnAHTNh4MLk2w58MuX5nthDUAcUYy+usnS2m+6T7sm1l5/T+cDFM+GCRArJHng
         SI+Z33absaHXv3L8G+ACMzZqD/994DoBUHpDcVKal4nrmT5r59vaZpfS/bd9F+Q5C4Bg
         MQjITz4FejfqH9dif4+Hs0Dmy2q8Z5/dD5QiXNPbsLMUz1N1NuUcs8BHCQT8PD5HnQNY
         w6MsZAlK+znj+DZonDVmsZHU54/oexfbVi5orSzzCxXtwFGqcIyWEvfDkTygosgzG97m
         q1KQ==
X-Gm-Message-State: AOAM533TzfCAwoRbb37dH/WUYd8uPfz4f8qKPmzEBxfvjI7mpXVtGrZR
        vdjbGILTeMGWvenfIwbhahLDOOKTASts6poWdwI=
X-Google-Smtp-Source: ABdhPJya3JcZmZ+67ZgolK7IzkiairySucGFBYEMhzBIf74Vmy4XzQQ+HAMpmBUWkge4t5ohjhQ+cA==
X-Received: by 2002:a17:902:e294:b0:143:86a8:c56d with SMTP id o20-20020a170902e29400b0014386a8c56dmr38666246plc.22.1637009266537;
        Mon, 15 Nov 2021 12:47:46 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id m12sm12749224pfk.27.2021.11.15.12.47.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 12:47:45 -0800 (PST)
Message-ID: <6192c771.1c69fb81.48c9.4359@mx.google.com>
Date:   Mon, 15 Nov 2021 12:47:45 -0800 (PST)
X-Google-Original-Date: Mon, 15 Nov 2021 20:47:44 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
Subject: RE: [PATCH 5.10 000/575] 5.10.80-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 15 Nov 2021 17:55:25 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.80 release.
> There are 575 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 Nov 2021 16:52:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.80-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.80-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

