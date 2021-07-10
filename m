Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C97303C3303
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 07:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbhGJFVm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 01:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbhGJFVl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Jul 2021 01:21:41 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D0A1C0613DD;
        Fri,  9 Jul 2021 22:18:57 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id d2so15128422wrn.0;
        Fri, 09 Jul 2021 22:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-transfer-encoding;
        bh=dfva2ED48ixbzO5ABeahW+BTc88vhqWMnmsAqk5nLrA=;
        b=lWuMKO+M85svJwwGXOvQWwopybJ+aUcR/F87k06/ECD9TARj7jMt9VRD6Ey5Jkl/cx
         c9lrRzprul3bzmUz0BGrfVESBq4XukAix5hmta6EQezUJTY8nwjdMdhJbWV9JXDX/B+K
         MyY5vgfahvI6S6glWuycJrfTlHJBX7lXhGws+MsBok/oXxNstHcwSiY53FkLnfKsM+ov
         aoAv/EPGCv4lqbBa2pGgprhnDTMLSjfRDhbd3vwQ6+VdxhTjq0y9ro1/Yih+SN7iODtw
         0KUKnNlCOMRgJCSyouFDJsjqmhII1LPH81ClS8kujjod8bdjXAdHN25IdcoRbNHXjASe
         1CIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:user-agent:mime-version:to
         :cc:subject:references:in-reply-to:content-transfer-encoding;
        bh=dfva2ED48ixbzO5ABeahW+BTc88vhqWMnmsAqk5nLrA=;
        b=oq73rqVpRP4IxlznfO3HRFRFEQvaNOfZqROqZf1asOMNsG67qgQ1SKWpkqPb1MLTou
         bCzYygUehoEZBNOPYgYlDpKuAZutW5IHAt+qavWosvEIdIgmo8NgVb/PzxN0qJCkRH0U
         /bIf0g/rqfui1J/MWMuL1tThA3gQTB1BuWo0oeis1OxzS1sXVQGGPn3OhkdWhQVyVqjc
         ilQaz+4z9X4Mf+udHbEXvkUiJtDtHHum2VEWi0StQkN3Uol/zlh70KyRDY59vwBz3pDV
         Vj4z3Fmnwb32z7kce6IwOuxk5QYKuuo7iilhsWUZAr8yuhzubZQytYboyx84tFgZu0mW
         OfhA==
X-Gm-Message-State: AOAM531pnrmbawv/275gqZhHQ4mjbeF44HCZYURNdrYza843YGFzCo1o
        d4ehRrL7PXxeC0O1peMeyMrJ3jNuG6Rn5piq
X-Google-Smtp-Source: ABdhPJx8GaOQvPhrzFWRykaJ0jgWcIi0+3vH4Vi0JnHeFxs7X6hbSEYTWBmXIVmOmNxWjC6aoxUGtA==
X-Received: by 2002:adf:f4c4:: with SMTP id h4mr5128397wrp.79.1625894335963;
        Fri, 09 Jul 2021 22:18:55 -0700 (PDT)
Received: from [89.139.72.61] (89-139-72-61.bb.netvision.net.il. [89.139.72.61])
        by smtp.gmail.com with ESMTPSA id b16sm7403404wrs.51.2021.07.09.22.18.54
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Fri, 09 Jul 2021 22:18:55 -0700 (PDT)
Message-ID: <60E92CF9.5040800@gmail.com>
Date:   Sat, 10 Jul 2021 08:15:37 +0300
From:   Eli Billauer <eli.billauer@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To:     Sasha Levin <sashal@kernel.org>
CC:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH AUTOSEL 5.10 46/93] char: xillybus: Fix condition for
 invoking the xillybus/ subdirectory
References: <20210710022428.3169839-1-sashal@kernel.org> <20210710022428.3169839-46-sashal@kernel.org>
In-Reply-To: <20210710022428.3169839-46-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Sasha,

Thanks for trying, but this is a NACK.

On 10/07/21 05:23, Sasha Levin wrote:
> diff --git a/drivers/char/Makefile b/drivers/char/Makefile
> index ffce287ef415..c7e4fc733a37 100644
> --- a/drivers/char/Makefile
> +++ b/drivers/char/Makefile
> @@ -44,6 +44,6 @@ obj-$(CONFIG_TCG_TPM)		+= tpm/
>
>   obj-$(CONFIG_PS3_FLASH)		+= ps3flash.o
>
> -obj-$(CONFIG_XILLYBUS)		+= xillybus/
> +obj-$(CONFIG_XILLYBUS_CLASS)	+= xillybus/
>   obj-$(CONFIG_POWERNV_OP_PANEL)	+= powernv-op-panel.o
>    

CONFIG_XILLYBUS_CLASS will be introduced in v5.14, so backporting this 
commit will break the kernel's build.

Since this patch was created for three kernel versions, I'm repeating 
this response on all three, just be sure. Hope I'm not being annoying.

    Eli
