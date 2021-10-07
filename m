Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 655DF424B4A
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 02:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240077AbhJGAq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 20:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239983AbhJGAq2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 20:46:28 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E304C061746;
        Wed,  6 Oct 2021 17:44:36 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id v2-20020a05683018c200b0054e3acddd91so896426ote.8;
        Wed, 06 Oct 2021 17:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KelqVb3ouOOggnxFCJCC51aZgdl5tYFWsKBlRfUGUco=;
        b=gQGADitmoyOHb2RJDPYbSX4zOMi9IaNy52GmhfsVxvCX3DZLmYwtoD43tKVFrZRDZ/
         tuMAGqNLrV2T0utwYAXvTmqad0VS1ntmnDd4mGrALl9aS5x1gPj3xmQPQ3dD3P5HerhE
         DoGSglVglVCWw23MKp5HGBiD9682NMZJAPrRiApQrMMtV8dKb4W/avKYYh3XE7up/2jJ
         8gpAKrwqJUvc1Jt7AiJW/tgAC1rTLj84rew9tMXB0jqabceoDfxJvWUxxcFUHz68siPk
         xD3w6vCAhcPwvoA3C8xkV1Wi9TG/kvgeOpGB2KiiP2WuPBj5WA/4jawgGZasYRvOzk86
         0Jsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=KelqVb3ouOOggnxFCJCC51aZgdl5tYFWsKBlRfUGUco=;
        b=lxt4xhcbFnVFtu7snK+iVByQGYyp8CaNxmv/nZBxwo3YK9/Qt/ccvBk/k4YW4+Rlbk
         Z3yHtzP2OUrfdfrwWfYCHUfo8SywlIY7JLvBw0dYy5yA7VOT6+8VoRBjt9rHLg7XoPw/
         r93VGmc3SY3hYtySt9egmqp0oLAS8ZKYVvW7Kt0BMBqxDkPT2CUa/lfvI2vJFQIuPaNu
         eeu4lgDruOJ0hUYxCL1QTeyxatXfEn2H4MQyDXWF8rQbdHwuF8xkJsvWheN7z5HQUXJT
         xO/xlxFOhOefreeUjuTsC1EN1spXbNnh43Y5zCYaONHm94xtwrGjw1eunLN1LLvK9FXj
         od7Q==
X-Gm-Message-State: AOAM531drqyDsf6e9Pkpfrjeae0mQJ8dEV2wcXP2dhI27tIGlJsEEsFF
        5aifhL9BJu9gJRXii7JjwKk=
X-Google-Smtp-Source: ABdhPJw+FE5aTJpmF8KLlisEqKIpwJZmrZrHVN/IYjWNR1G1Fq5eoCl5qdatn2UEkZ0md04gYLUzwA==
X-Received: by 2002:a05:6830:3151:: with SMTP id c17mr1193575ots.364.1633567475501;
        Wed, 06 Oct 2021 17:44:35 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 33sm3759398otm.28.2021.10.06.17.44.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 17:44:34 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 6 Oct 2021 17:44:33 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.14 000/172] 5.14.10-rc3 review
Message-ID: <20211007004433.GG650309@roeck-us.net>
References: <20211006073100.650368172@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211006073100.650368172@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 06, 2021 at 10:19:58AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.10 release.
> There are 172 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 08 Oct 2021 07:30:34 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 480 pass: 480 fail: 0

The new warnings are now gone.

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
