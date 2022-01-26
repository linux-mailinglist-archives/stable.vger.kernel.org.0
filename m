Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2F9A49D094
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 18:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235170AbiAZRV2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 12:21:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbiAZRV1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 12:21:27 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF72BC06161C;
        Wed, 26 Jan 2022 09:21:26 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id c3so183124pls.5;
        Wed, 26 Jan 2022 09:21:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=CU635gyEcGUfu9rrYkgOvJLpCDM+lhOsMSeDOwBn7MM=;
        b=KSFqGNiuh/TLdDei34uKTlnM81BLbvQxXfVKYXWvQZsH31cLBKLmtXQTvkBVUBr9Xo
         ODp0hbzupm1lz23IXCXOm9bicl7lBhNgjxf3HXY55EiJoK6wKuJ8YPTgfuL4VlVZK8oX
         VHpJAvyWJ40p3x8vwgetPDJgm5Pq9Eh0UVxTyEIINoWlZ1ysGnmO3nV4CAiYkRzF4IVS
         ADH6YJQyB6i7b276i6rRggyCEb6bjb3XdUla0+ryRrGj3qe/2GdMkn6lsYyObWQ4YjFq
         AXSSfICIFARCb90TmhUVy76dVVhFL8/SRZ0UsJLzmAON+kyQ/lAfxK7pCPs7DphDSeu1
         xuMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=CU635gyEcGUfu9rrYkgOvJLpCDM+lhOsMSeDOwBn7MM=;
        b=vSjFvO8TpZ3XvXWl7cUAnNnAsVgDrWTgSUTUrpGah/MBP17KYbQ1WR+0JDvoSI1vPl
         xi2bG4dirzdh3/AYAnuFQUmt5yPg+KDNNqutDjheQH0WAAFkhYDxRtsFIRNbjlK18VK0
         J3V3sn056oDMzmu2ESYyzSpsLEJDZ8DZUzOd9z6bnfombStK5zMpKBJIiNh+qDJNKQ5D
         UjZJAxTol3fK7PaT6KJ7RrT1EUVn3OzyQdfx4K+ypAnE1kmb3FAJ2+GmDLwKO5Ah8gx1
         H6Yv/0+KrBrw3STSlOiEXrcPctNTxY5XlYu5QPcYJD+5algQBRPvK8SM2QWvKC7Vk1hA
         jDog==
X-Gm-Message-State: AOAM532JQfOJjnAX/oknFavAFI7tvsmSIqmdV+Byh/h1uFau8+kRBfUI
        vjwJb2gZ0VgZutrUivv4Y2cNjktDh+Sb2x3H/dA=
X-Google-Smtp-Source: ABdhPJx2FFNzmZHhB6RjAqL19W+AmJtdHKn9hhOlueGxXA2t/Qk/5E7TeoMGljFFycDLj0PLwWXL8A==
X-Received: by 2002:a17:90b:4d8a:: with SMTP id oj10mr9650947pjb.201.1643217685522;
        Wed, 26 Jan 2022 09:21:25 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id q21sm2823250pfj.94.2022.01.26.09.21.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 09:21:24 -0800 (PST)
Message-ID: <61f18314.1c69fb81.95468.804c@mx.google.com>
Date:   Wed, 26 Jan 2022 09:21:24 -0800 (PST)
X-Google-Original-Date: Wed, 26 Jan 2022 17:21:23 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220125155447.179130255@linuxfoundation.org>
Subject: RE: [PATCH 5.16 0000/1033] 5.16.3-rc2 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 25 Jan 2022 17:33:08 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.16.3 release.
> There are 1033 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jan 2022 15:52:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.3-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.16.3-rc2 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

