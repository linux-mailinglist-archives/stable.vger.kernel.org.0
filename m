Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D062218F42
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 19:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbgGHRw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 13:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbgGHRw5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jul 2020 13:52:57 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4003C061A0B;
        Wed,  8 Jul 2020 10:52:56 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id md7so1515740pjb.1;
        Wed, 08 Jul 2020 10:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0iTBy9GkFXEz3ueB+YO5lIF8vJWQu4NUuyz+31jVtaU=;
        b=FGoqOJB97ePWbmUbX0i8s6Uyk6b42nRUv98G8mEUpHqDOxJ8b/CiChJFhjRKteua7e
         wqr545QaNiQ/XHAjmHoCP4IEuYIcZvxkDMN2IHPQDSbvd4akGHr3OZvtWq1JvOaSfWvr
         EznH9oHr9drQS+xNoTG7vUW2yg2qPE+Nv4wXIdJ3WoW4CBjJHRzRd/MXaFQkslLRRBSK
         y7xBEn4rk6nGiNtMHprYK8yZ+Ry5+ENXU7ZcJ0ZnPgR5r9jrYu6hFeBk0r5A/LSa6NBr
         Vn2Zb+dZaRO4e5UAohriTOT55bgOvCWgZN/q51DBErNylNvgez+CPQzmh7abpm2ms+pj
         Nh6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=0iTBy9GkFXEz3ueB+YO5lIF8vJWQu4NUuyz+31jVtaU=;
        b=RXPkhl7EZorbc4WadHJDdfkGl57V/W9Xx3vncwHNBC6BqXb30zsXCgR/j1KkPzLJMs
         pu9FlQnf5+J1IwuAGUeS4T8wkWb9ScLxMJ+k09/gKEcH5kbH39wWNTAhiZx64cbUkw2T
         BgbaaE8sx/zPbhJMpKIsJfCzlzmdiQuRCc5OY3U5tBBf29dzuwPFpqtm42vpvNdlctbA
         ywxW+fDyNkLXh9hfeQTt1TsX7SIuZzcGq0AB4tgTvcHFZoAoDVJKBzzv1wD/zy1m+R6r
         99LG+eypLWs8htLp8fx7+Sg3eSuOzaa3/yMJLqGIrxBsgSyKA6IQ018wQB7OZ/vD0mvS
         pivA==
X-Gm-Message-State: AOAM5337IgJNmIO3V2WY7PzuW/DEDSxJYEcuRsq6STJPf0P3PCORWDsv
        5145u4bsjkKhueuwGAIsncnG1J/pW0w=
X-Google-Smtp-Source: ABdhPJyfNhyICJcXmC6zCry4w6DFCr0PaQ5a5Bxga4WYqo1NcpqYLznFfZ91UktIJEKBEl183xy6nQ==
X-Received: by 2002:a17:90a:6acb:: with SMTP id b11mr10671566pjm.71.1594230776633;
        Wed, 08 Jul 2020 10:52:56 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y27sm432832pgc.56.2020.07.08.10.52.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 08 Jul 2020 10:52:55 -0700 (PDT)
Date:   Wed, 8 Jul 2020 10:52:54 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/36] 4.19.132-rc1 review
Message-ID: <20200708175254.GD224053@roeck-us.net>
References: <20200707145749.130272978@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707145749.130272978@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 07, 2020 at 05:16:52PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.132 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 420 pass: 420 fail: 0

Guenter
