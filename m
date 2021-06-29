Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD9D03B77C0
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 20:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235127AbhF2SXe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 14:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235073AbhF2SXd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Jun 2021 14:23:33 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB4DC061768;
        Tue, 29 Jun 2021 11:21:04 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id 110-20020a9d0a770000b0290466fa79d098so6967799otg.9;
        Tue, 29 Jun 2021 11:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QgG8curSfikvSy4uEUf8j7CexQoiMPQXh+YIlMOnPgo=;
        b=q6QsOm1U3JlfrI8ABAn7akC9krsjj7Y9ifXvShCwvHE3VgmAVDklYWcMzHW1YMAMqw
         96mjnKt3ebzrOFc+9w/CFhIJtqq/XxE3Dn4vnL7N1mQ7Xtcdf7796CjcPgDgyAWPESFT
         bYMe+vt6FG0v1aMc+Bd7kI3APAyFVmYPmtXoh/Jspo1BKebDqY/fgM/pinEzt7ZUB5p1
         VoB5sgTbxaaxywbBfNPnJDaEuLdtV7utz6EwAqB/dBC4DU4gBxdk6nz4iD7t9OiC7sy0
         VVuDXE1h/ARQBq2lbKgWHa6sDFkhS7uvOCzgcYujbi7wLFI63nMWitj92V9/yknVHzT7
         o/BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=QgG8curSfikvSy4uEUf8j7CexQoiMPQXh+YIlMOnPgo=;
        b=Gex9qabJ1NrRhkykYJtmjm0VONmK4AwRJz933rbmQ+6tcYEjgz6wJj5P2IhXz9Jj4K
         9WqiTwKyWX5mbmM47AUMGkySBb0jnrZsn4/bxB0vhOexQqEjCN9IGfZ3ec7Gw5C2zbIh
         TIDKBoY+2LMIbz/QK97ooTM8nqSwyIIpfpsq2FXYojjTU2HwM0QXqW96LnIDLKrXjOIS
         vkq/R0pvkuYc92B/WeqACJp0NQKLYlakkG9sALzKz1zSlcUXaSDA/we8W/1I+UuOhsN4
         C0tjUT03py8m17sl9mTrrINQI6T9gYpngoWoNpS1UfQgvPK2TeWq2MOsUCg7D0E+8NqE
         7IPA==
X-Gm-Message-State: AOAM531M1j/vAEkKxWFkmpakd4F9G8RDcbjZVt1DA9P2hPN8qL7Z/wyC
        yeXO1C3VyCBCIos5mXpo7HM=
X-Google-Smtp-Source: ABdhPJy/EZcwqLG3D17ah3ntF/y8+EJ2cf5MUr6W6BvIkEq185HV6bpq7nauxbSIe8Zd7W3cHc/ctw==
X-Received: by 2002:a05:6830:2252:: with SMTP id t18mr5672482otd.152.1624990864026;
        Tue, 29 Jun 2021 11:21:04 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f6sm2543089oop.31.2021.06.29.11.21.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 11:21:03 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 29 Jun 2021 11:21:02 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org
Subject: Re: [PATCH 5.12 000/110] 5.12.14-rc1 review
Message-ID: <20210629182102.GG2842065@roeck-us.net>
References: <20210628141828.31757-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 28, 2021 at 10:16:38AM -0400, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 5.12.14 release.
> There are 110 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 30 Jun 2021 02:18:05 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 151 pass: 151 fail: 0
Qemu test results:
	total: 462 pass: 462 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
