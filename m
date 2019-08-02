Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7A7E7FDD1
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 17:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732098AbfHBPwN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 11:52:13 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38670 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728853AbfHBPwN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Aug 2019 11:52:13 -0400
Received: by mail-pg1-f194.google.com with SMTP id f5so27452107pgu.5;
        Fri, 02 Aug 2019 08:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=hChDQjNk8GUmuij0Tgbi8SwYKa1s6wH0+tWWLC518GM=;
        b=H62ndNIWMkZFY99KdV8g7328EqmF8Cfv2MxDALDkR3AicphGsEBZgREcnS3yRaCURA
         kwZi/AjaSv3+Ib+0eg3bIdoagdKyi9GWLWTQRvilDY+4oimO1u2s3SleBLxYaIPHhR5P
         JFCOO7rniPkz8e6JBg+tBJ1ao3ahqTPWjTKO/Z2IFwY4uYY+X0/946l44DdNiQIBcbn4
         c+xFzWkWjzK/T8qfHW+/GLlPmsaPzsn6BYAfWgcW4dWFFNNPT8fds3SmUcseTtWrl0v+
         yFgbRryo3YxoylXz6+w1C6OFFC6Fyo5zUIpekT5+V6rrMrpbPQ6E3zJHMy4W8byclf5d
         Y3pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=hChDQjNk8GUmuij0Tgbi8SwYKa1s6wH0+tWWLC518GM=;
        b=KzYHaYSrDZmBBC3JcZmoa/ky6AkYmcH0rWgwcjc2yvFnsShsdvV+b7y2FHIG8NCTPj
         9+9olkeT0Ytutq84bzj+9sW51FR3k3TBvgLn+LxiB3T6+zJ45d7goibh/0uwgr7S2/Sq
         OF7UcOK5sG1NXzPFa4j33eOsAyGielFmS/5k2ut7FrLhkZpzHxlm61+XfAJwp1ib3U7X
         n5FHPQCscm+u5iNo5B5J+Kg4xwxa5PRrWgadQCmsyLORQYFsoi7vHIGGMCQ0nuH37oVl
         UShVzHeK5IqA4YQppJo3EitcHb+A1TpSpl5I7zyu0sg3o4O0vue9LfMHmABPk8Xyq2mG
         21Qg==
X-Gm-Message-State: APjAAAXt8ADbJ73grtX2VIKpAtOCS7EAUCwfVveBI13tEEA4iqO2YcXv
        Z5sVVqcCU83sLiMpDRyL5S2ksCCX
X-Google-Smtp-Source: APXvYqxNYR7vQ/Q5dOkKE/cgMjgVMwJinSCWlfNScUZc8Exyjci5HbhrgMoRTSxWlhi2kT2NuKUvgw==
X-Received: by 2002:a62:1515:: with SMTP id 21mr61833169pfv.100.1564761132988;
        Fri, 02 Aug 2019 08:52:12 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 64sm77118725pfe.128.2019.08.02.08.52.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 08:52:12 -0700 (PDT)
Date:   Fri, 2 Aug 2019 08:52:11 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 000/158] 4.4.187-stable review
Message-ID: <20190802155211.GA25315@roeck-us.net>
References: <20190802092203.671944552@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190802092203.671944552@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 02, 2019 at 11:27:01AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.187 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun 04 Aug 2019 09:19:34 AM UTC.
> Anything received after that time might be too late.
> 

Early feedback:

Build reference: v4.4.186-159-g26f755a0d3e0

Building powerpc:defconfig ... failed

arch/powerpc/platforms/pseries/mobility.c: In function ‘post_mobility_fixup’:
arch/powerpc/platforms/pseries/mobility.c:318:2: error: implicit declaration of function ‘cpus_read_lock’
arch/powerpc/platforms/pseries/mobility.c:325:2: error: implicit declaration of function ‘cacheinfo_teardown’
arch/powerpc/platforms/pseries/mobility.c:332:2: error: implicit declaration of function ‘cacheinfo_rebuild’
arch/powerpc/platforms/pseries/mobility.c:334:2: error: implicit declaration of function ‘cpus_read_unlock’

Culprits:

9d263cc3b7c1 powerpc/pseries/mobility: rebuild cacheinfo hierarchy post-migration
d4b0908c6289 powerpc/pseries/mobility: prevent cpu hotplug during DT update

Guenter
