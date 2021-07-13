Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E84A83C794E
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 23:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235797AbhGMWAn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 18:00:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34047 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234947AbhGMWAn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Jul 2021 18:00:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626213472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9NqpBaF//aj2A9EcG9Kn7g2tzsF0+GouVQxjJctCg8k=;
        b=ETyd8lO5eTylz+e8BB3Unvu6MinloT+8gNRzkzLMdXjTJ7tpzVDWHlbIk2OFLP/FXw23CI
        2vLvZIuGhvlnXeBC7Q4lq4LnvbRHTf51DTIQvogGX6fIXX1r5dFDDCSxyilEq9+YG919xz
        wpuSySVOqR6w9O+c9o5k2PRQGm8fLFc=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-gD07oOdEOymIc57L8UOiKw-1; Tue, 13 Jul 2021 17:57:51 -0400
X-MC-Unique: gD07oOdEOymIc57L8UOiKw-1
Received: by mail-qk1-f199.google.com with SMTP id i190-20020a3786c70000b02903b54f40b442so18499248qkd.0
        for <stable@vger.kernel.org>; Tue, 13 Jul 2021 14:57:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9NqpBaF//aj2A9EcG9Kn7g2tzsF0+GouVQxjJctCg8k=;
        b=TCjKj6uXc+vg+EnrUoDbWST0aQwmZjkP4dCfZaovv1MadJQEPGCcVR4sOZkYHQFveO
         uhv6o7sNw/wA8pAWBpeOfLnp9UfPKxnLsKfqpU4+oixCIo142m52rBXZZgDwZ4zauzDs
         QfahrwbtJU2LT2ZnTgUe/QlWJxzDjMPGoHtgjA664js5NPpSayKcIz8jO2CoV9ds1QSA
         4xwgASEF1vM5WrRaWIEKrm9Yg0R9cNeOlyfKyp1SbmPgPSm1tMKmLzb0EiD+Hva38U+x
         orGhWcdlk9V9Y9eke048nyqZUHo+pNMlOeLQKruFbs7CSru0Li1tnfHKMdek/yilRFVF
         Xc7A==
X-Gm-Message-State: AOAM5324FgdynxuQa6R9bSRdS8HXFRDwAkQyPn3hhaeZ7XHEqjE2grD6
        NVjQdzDFWxHgvxIaq39HMywx7ByQcrcXxqiSPZs4uB2I2OT3KEAvN+vGHML+oefYh7stEvvjame
        OYigZK41SP1SNbisE
X-Received: by 2002:a0c:a997:: with SMTP id a23mr7246724qvb.48.1626213470878;
        Tue, 13 Jul 2021 14:57:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzCT4xi3IffBENgN1FcPchFBX/OcsAOPopINVu0g0LXVH6ZButpHKZ/v5QNj//JjJPmr4qvEw==
X-Received: by 2002:a0c:a997:: with SMTP id a23mr7246710qvb.48.1626213470679;
        Tue, 13 Jul 2021 14:57:50 -0700 (PDT)
Received: from loberhel ([2600:6c64:4e7f:cee0:729d:61b6:700c:6b56])
        by smtp.gmail.com with ESMTPSA id y26sm98439qkm.32.2021.07.13.14.57.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Jul 2021 14:57:50 -0700 (PDT)
Message-ID: <b8ed5382e6162fbc8639002cdeffec3007ead5dd.camel@redhat.com>
Subject: Re: [PATCH] usb: hcd: Revert
 306c54d0edb6ba94d39877524dddebaad7770cf2: Try MSI interrupts on PCI devices
From:   Laurence Oberman <loberman@redhat.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     linux-usb@vger.kernel.org, stable@vger.kernel.org,
        emilne@redhat.com, djeffery@redhat.com, apanagio@redhat.com,
        torez@redhat.com
Date:   Tue, 13 Jul 2021 17:57:49 -0400
In-Reply-To: <YO34tyvp/hkO+24F@smile.fi.intel.com>
References: <1626202242-14984-1-git-send-email-loberman@redhat.com>
         <YO34tyvp/hkO+24F@smile.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2021-07-13 at 23:33 +0300, Andy Shevchenko wrote:
> On Tue, Jul 13, 2021 at 02:50:42PM -0400, Laurence Oberman wrote:
> > Customers have been reporting that the I/O is radically being
> > slowed down to HPE virtual USB ILO served DVD images during
> > installation.
> 
> Side note:
> 
> Simple changing
> 
> -		retval = pci_alloc_irq_vectors(dev, 1, 1,
> PCI_IRQ_LEGACY | PCI_IRQ_MSI);
> +		retval = pci_alloc_irq_vectors(dev, 1, 1,
> PCI_IRQ_LEGACY);
> 
> should have the same effect without touching tons of a good code.
> 

Andy and Alan,
I tested this and as expected it worked as well.
However David has given me a possible ehci fix which would be the best
outcome you wanted, I am testing that now and will follow up tomorrow.

Regards
Laurence

