Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDFAD3CC444
	for <lists+stable@lfdr.de>; Sat, 17 Jul 2021 17:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234930AbhGQPt5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Jul 2021 11:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234432AbhGQPt4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Jul 2021 11:49:56 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55FF1C06175F
        for <stable@vger.kernel.org>; Sat, 17 Jul 2021 08:47:00 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id r125so11979634qkf.1
        for <stable@vger.kernel.org>; Sat, 17 Jul 2021 08:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=qFalPCemBWV61xEz1gtroA1HsiotVyeTorhQU8j6JJY=;
        b=CSd4OqxOV/Id6IoJvQclBZdCnQbXnpcffc/n952f2k1+NYKBCTQXyFnQI7VyIOFHH9
         qVK4NsOs9DJAQzXklvUOiFnKMjApfb+wnQII7DfSRassDfRlHkKuz5yENGUC2+lClUqR
         8gVzLArNKXKEt5UhGmVXeUN5Vs7t3uYct6Fo6CeaAK8iMi+iKHDvtLTmOkfZjK9tv3k2
         dHuopdIkuI1/aqQlrmFg6TyPb2dl2EPLGhUtNAxgwltFBoVAACqGKXYmczYMtFU4ontg
         lFGwHO+9e4aH5mltynEKcjRqD/ALQ0fIvbVO+NxqHOdn62F9YYFaZrQXoTQRF4RoXh9u
         GfdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:to:cc:from:subject:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=qFalPCemBWV61xEz1gtroA1HsiotVyeTorhQU8j6JJY=;
        b=Vo2UhYOQ51QJ8spYFShlivvGyJ+HpqrxQ6Avl3XDHC6LeTEh/TK3RTQI2ixS4F9iXW
         YEWifrOcC1Jmm3Jcybt+odgAAdTxVdiYe7ZDAnicwYMGj3jnloEFmBYaTEp4trizFdIU
         F7aefnXYa9V9Xpgugav/sw3O5Ivgdauz37tBFMpcIyYbrdpZE+A/DVzVprd8c+yT+gco
         VB8sBEYw9FgnNCfhXEVB8dFwOL2qKdt/2U3K1VIZ/2NoWTs+ONRcKkrChYhv42SH4GC1
         A/WKdUwhAs+R/HaBtYD40FeVenyxsxkIElz38APXig/lcwa4vVf7kHjvmfsyuNth+tH8
         sbxA==
X-Gm-Message-State: AOAM5327rXRVDrcebCj4i4sjLgJeh4gzycHERFN9QmbBu0I0sHWd3ZM3
        Ngk7gA+yi0l8mf9OjPai7Y0YQHXy/hQ=
X-Google-Smtp-Source: ABdhPJzgSotI32LO8qrqPOrUnhUBCjcH+lmxUHf9uXZnHwk9LwHBLdNbHHIEYLz3F9SSnJ2ACNjQ/Q==
X-Received: by 2002:ae9:de47:: with SMTP id s68mr15541461qkf.39.1626536819543;
        Sat, 17 Jul 2021 08:46:59 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q184sm5345145qkd.35.2021.07.17.08.46.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Jul 2021 08:46:59 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
To:     stable <stable@vger.kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Build failure in v4.19.y-queue
Message-ID: <a4a8e5d2-7f54-d8e4-67e6-365bc31fd28a@roeck-us.net>
Date:   Sat, 17 Jul 2021 08:46:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Build reference: v4.19.197-317-gb088d8812da4
Compiler version: powerpc64-linux-gcc (GCC) 11.1.0

Building powerpc:defconfig ... failed
--------------
Error log:
arch/powerpc/kernel/stacktrace.c: In function 'raise_backtrace_ipi':
arch/powerpc/kernel/stacktrace.c:222:33: error: implicit declaration of function 'udelay'

Guenter
