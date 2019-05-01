Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A177E10B86
	for <lists+stable@lfdr.de>; Wed,  1 May 2019 18:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbfEAQoc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 May 2019 12:44:32 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:40025 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbfEAQoc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 May 2019 12:44:32 -0400
Received: by mail-pl1-f195.google.com with SMTP id b3so8409247plr.7;
        Wed, 01 May 2019 09:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mLW1IJtKcn4AO05PMMXbdDMKQlkkrPR+HtN72nu7gJA=;
        b=KX1kJh9q+gxShrD1asj6IlglPgupIkL8J9+5jcCaZN7+WQpDb9xGXO2H7pSY6EPWus
         PKVRkWtsBDRB5UyZs8C2vzA251I+XwKGfAXPT1YYIfHNljMwjnpJMFU8pWUtQVjasuv4
         sNodkf9Ed/q8Se4bKIqtehXfwauYQ6MdX46zrwdv5iwVy2usfIakVqbnjwlMByhvic3Z
         YSbG9fo9JGBngeW51mjF2OE1IwZlwe4zQcsNxOQXhRJQaIh2UQCVZSEe1VFiZ2i9e1g3
         w8wzGmo9oNTx0CR5rggjTm5hyiRSyjvj1ffODdiSeqAkRnIVPzf89nRkX70De2TFD0dj
         wVwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=mLW1IJtKcn4AO05PMMXbdDMKQlkkrPR+HtN72nu7gJA=;
        b=JucP7aXhabQH4wYJNm6DngYUiWHXYOmSAaXXJ7lS2lq7Kpue/owqwKZ1+/O2b3wlkv
         7bJOnQEZL26nctUttyp1f1W3CpM0QOyktJMQCXFm9biOYZQSevDqbqRmbPWjPpFv251K
         NlSa82Rq9/qouJda59gUke1jYeurEj0ug+63SC+IG/rdq9K4uChP81oDlBoHeG7p3cbk
         Opn3Gfvr+w63BeH2jS+Hvmap/BEiUBwnRbEcIhvd8sZ8tYRDeR8Stz9cV3vh3H/OflhJ
         zCGuFvjNuTytdmgxM2uiHqHsi8doXV33q8fh+XRdk+yp/B9gQpZEUxMpkpVKGa1JXn5S
         ot8Q==
X-Gm-Message-State: APjAAAVBJ6dH/purBr+221UU5TO1uaQTMad5X8HnijULZSOINvpeTNWG
        69eNJ8mYC3P3zDoVYI2RXkY=
X-Google-Smtp-Source: APXvYqzD4dpfbxUhLW9ntFB+D1YLkOZK0b99riOXtBxiVDoEJw8hXKlkNoGkJe36obg0Dnn3xg4MHg==
X-Received: by 2002:a17:902:e287:: with SMTP id cf7mr78599264plb.217.1556729071986;
        Wed, 01 May 2019 09:44:31 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o2sm59961580pgq.1.2019.05.01.09.44.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 May 2019 09:44:31 -0700 (PDT)
Date:   Wed, 1 May 2019 09:44:30 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/100] 4.19.38-stable review
Message-ID: <20190501164430.GC16175@roeck-us.net>
References: <20190430113608.616903219@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190430113608.616903219@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 30, 2019 at 01:37:29PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.38 release.
> There are 100 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu 02 May 2019 11:34:55 AM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 349 pass: 349 fail: 0

Guenter
