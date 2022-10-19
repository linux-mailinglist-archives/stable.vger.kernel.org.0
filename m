Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99C8C60521C
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 23:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiJSVju (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 17:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230354AbiJSVjr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 17:39:47 -0400
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EA6865246;
        Wed, 19 Oct 2022 14:39:44 -0700 (PDT)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-13ae8117023so708437fac.9;
        Wed, 19 Oct 2022 14:39:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CSYItm3BIqT+lrnqxjZIxoxYlxk4bXzGi8d0VD/QWug=;
        b=VgxnS3kSACYY7DLiSvk/cwSCffLWwXdhCKAzKhcuoyDAidLkfG/a8D7bd5gDQXWvFf
         7eRwZFxSor7ruUXvQsidQB4TVBinamqLNSFBf7F6zVnkRA3IhZ4aDsVvKpq3fzDt9Ywf
         vOldUHqZZ6ujUlgOo0m+5KirHVGEYbCW9hc8qBips8s9oFpbD8bT5KHV1f2YVNqLFb8w
         IXZ/015Gfs++j9MFTbdh9GDUZW14/I6JCm7KFABBWVGuHK5i4hB0G6MBZJiW5e5FMFZE
         eydcdNPWJiSUaDiJeUIlYwXX8lJxgZmKUGsIhlrVV7hbAR3LsmubSboOfizktGgNkGHo
         CWDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CSYItm3BIqT+lrnqxjZIxoxYlxk4bXzGi8d0VD/QWug=;
        b=LgUK1SnOssKcrGv0Mb0roQCOnON6mpi/hq1y7uWP9ZpqgMj/ZU9JZ3rrHDPiQ+PFR2
         NNyFLiR6l8oAKvVe371RkacYwopt+1BOwrMy75bw0gZlmlwpODB6Cpe8F79eMv8wgxTi
         xHtj9IXSiXlpffYhm75ICQq6jWhAHdMjMYk+Ld0weizDWGmaADn+NtwyKyQlQovpeQ99
         t34XrP4jujdMzpMQisKVVj2tXVqbNIqi1uwyMGVbkoTqJxYDpq5saVXpRLMUjZJYVSNA
         0SgfoA3sNKVU+/no+7leln+/7+l9WsT6PWpT9eW/F8AJcz/3CARHdl/9tlx3LfdLKBCR
         9cjQ==
X-Gm-Message-State: ACrzQf3mC8no/WZC27G/nur6Ll4cH5xRNDRNc+zNvI0jUCTkvhbcDEGu
        FCN5KFzStnDgFs1AHewhtw4=
X-Google-Smtp-Source: AMsMyM6m6xRz+D0YNIsB2zjKpRLfZ+jOURU5ykjUi7EdsSUIzsDumbFPodE0HYznfys8HpRRSk/pZA==
X-Received: by 2002:a05:6870:ea9e:b0:137:a7:3cae with SMTP id s30-20020a056870ea9e00b0013700a73caemr6401388oap.48.1666215583949;
        Wed, 19 Oct 2022 14:39:43 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l10-20020a4a434a000000b004768f725b7csm6869857ooj.23.2022.10.19.14.39.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 14:39:43 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 19 Oct 2022 14:39:41 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 6.0 000/862] 6.0.3-rc1 review
Message-ID: <20221019213941.GA2632115@roeck-us.net>
References: <20221019083249.951566199@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 19, 2022 at 10:21:27AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.3 release.
> There are 862 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Oct 2022 08:30:19 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 152 pass: 152 fail: 0
Qemu test results:
	total: 490 pass: 490 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
