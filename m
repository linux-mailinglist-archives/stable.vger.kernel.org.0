Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFA1260C29F
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 06:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbiJYE3y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 00:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbiJYE3x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 00:29:53 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E30E030;
        Mon, 24 Oct 2022 21:29:51 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id p127so12968026oih.9;
        Mon, 24 Oct 2022 21:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FKmw9mg6s3KIgoxKqqCs0dz12P2bX1vrRQcR1znp9nE=;
        b=a6Xuol/qR6I3ct3JvZyCkUtp4lMCdCIypDkyr2RMlENPym0vrkvYM8DodAWWwsUTAN
         E8gvFcr/taXPPgISvx/yrrc489zJb947aiw9sTKi4bgWJGDcGaal88DmKLcmxa0yaLQp
         F+sFdNVeyIjmSpNQXjWJmWu02vRwdaxPUOfGLYA/RFPJ7rmJDK6rzLIqjhPVkXqDZbI+
         CBk7FRb3MqAsQHFcBoOF1eCc8CDFjw+tNVjBZHIBpPpX4qw/YVjcKjwNd2kJ0wUAtoWy
         kHsZk6XqUFY+/qe/8t6GRGkH875Uk1/jEc9ShE6YA0casXrMFVmcfz4uWL+3VLqJTwhR
         hmlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FKmw9mg6s3KIgoxKqqCs0dz12P2bX1vrRQcR1znp9nE=;
        b=oRLw2zKmU3IYYaWF8zRefle6b7eGB1pK6z9sof6N9MtI5hpyBojmEYfFqGVIQjRufh
         O0jqE6iNQmpG2Uq23DPjj1+oIcreDnU4MGnFcBJ7gealc7Igs56sBCY07+mclilo6uUY
         YPYk3g9ek39w3JwUK+pekI7vxqgCof0ItZlmfU6G1UYxUVCVpUVTMkzo54zkNrBq6FuB
         zluFZUgfseZjnrHEOI+QH9zTQ9G1TG8jj3iqkG2BCePKha1VOgBJUe2F74vazsZWfxi/
         6I1I5oVUmYGfcjx8l3SdLbfkZwVt6VTl9qTQMiB2V1TV5ub2OOfCMKDtsuob9TEHiEnl
         +DBg==
X-Gm-Message-State: ACrzQf3G30Rx92r9BTTjJ/DsCSzgzUb8tlK8R8zwToCGHFjffiq8PsPK
        tGNt76zp/K3vCpTw4w+FRJ0=
X-Google-Smtp-Source: AMsMyM7+opT1ZCsEUcxvxc9CnmrU5dYhyJmVJgoHHFdt4LoN88gf7L+LjfnzwB+HVAGZV7STy1zNUA==
X-Received: by 2002:a05:6808:23c3:b0:351:4ecf:477d with SMTP id bq3-20020a05680823c300b003514ecf477dmr18400311oib.126.1666672190398;
        Mon, 24 Oct 2022 21:29:50 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r25-20020a9d7cd9000000b00661ac94f187sm600515otn.42.2022.10.24.21.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 21:29:49 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 24 Oct 2022 21:29:47 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 4.14 000/210] 4.14.296-rc1 review
Message-ID: <20221025042947.GB4152986@roeck-us.net>
References: <20221024112956.797777597@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 24, 2022 at 01:28:37PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.296 release.
> There are 210 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Oct 2022 11:29:24 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 170 pass: 170 fail: 0
Qemu test results:
	total: 422 pass: 422 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
