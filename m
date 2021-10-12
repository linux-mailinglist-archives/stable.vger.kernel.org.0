Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7B52429B48
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 04:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbhJLCEF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 22:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbhJLCEE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 22:04:04 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97C86C061570;
        Mon, 11 Oct 2021 19:02:03 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id w12-20020a056830410c00b0054e7ceecd88so6133416ott.2;
        Mon, 11 Oct 2021 19:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dGS77biGEVYZPNxQG5cg57ElQA9NN6lK5mWeN0B09nM=;
        b=GPePzki1Dh2zsh/kEGudD8VPrkZLJlic3CURFT5wVrUz9sJpe4Hz+0BTKU6G7i+q6l
         daK0+JTFYgWkkBh65Y5eRODVZ9TuTeVaM0usk3k36+2uJ4A/1jQ/ioTl6Z0M2K5fCw8W
         i9q3Qsay42HBFQnb7klLZXqQ1ZBmpODdbuC4RXZOrzDGdr7cWtEkMUTGKU74d7jFDQXE
         o+9Tz9MTCsJmqf2rc1y2ZCycZMXN4+mvnmOQuPDCvfZNWsVyUTFi8htgES5d9FQNR6/B
         qr5oK8hvkXzKXZ+AxtW1Ll+8WPI0HEOVm7xo+Ye2+GJwZXSGfnRIESvUtERklz0tlgy9
         OQAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=dGS77biGEVYZPNxQG5cg57ElQA9NN6lK5mWeN0B09nM=;
        b=dljg1/0h1J2r/B9zbgF1iUovtemxBJDqiyzF+/rO6MK7nl5K2FzlMlwHo0ziswDW3j
         A4BXro92IPi+I7xKq0kLY0jSXhJolNf7nhQC6AVsG8XtFyDDmh354ONcPbSqbJZv7VQA
         IjZJYA1FCr+6e4sG0yvwq1+EO5Q+BT3asOHjDhiY9wOFn9QsnzJvHA6nUbP/JFyD2X0G
         PpsYk+wuTmnTY0E8GgK9sfT3gkTZZnJQyDIkb9OcySnPFvLCn/ToK5bny8Z4dmHFjs8y
         HD1RY43qmtJPqH4T45Jbw03zbb8CASy7J5s6mzVekUF0P6jMF3sXrO4JFVEUM5BvKBf1
         mtQg==
X-Gm-Message-State: AOAM531yPX3G6qVxH/x8MOiVJVThieFnnm+JBQ6eWGDL/NjCpHHkxWkh
        hbOA+Iod5oGw6JRxbcIpyaY=
X-Google-Smtp-Source: ABdhPJwn1aZr8135b9Ubs9m/GwXeUwTj773YF+xWmkljpkYiSDZ0t8m4OuPVIL3GRGfycgvQwg+b9w==
X-Received: by 2002:a9d:871:: with SMTP id 104mr13713520oty.132.1634004122983;
        Mon, 11 Oct 2021 19:02:02 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h17sm1825455oog.17.2021.10.11.19.02.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 19:02:02 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 11 Oct 2021 19:02:01 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.14 000/151] 5.14.12-rc1 review
Message-ID: <20211012020201.GD2033605@roeck-us.net>
References: <20211011134517.833565002@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 11, 2021 at 03:44:32PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.12 release.
> There are 151 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Oct 2021 13:44:51 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 480 pass: 480 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
