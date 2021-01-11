Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7E12F2239
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 22:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730167AbhAKVw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 16:52:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbhAKVw6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 16:52:58 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14E65C061786;
        Mon, 11 Jan 2021 13:52:18 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id r9so316063otk.11;
        Mon, 11 Jan 2021 13:52:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pWvSLP1WxF8yJq0CNCIWrsEahi/aazph8leWknyqaLg=;
        b=vRvoN3DKe8HTH6Xwpv4lM8qoyeIlihRX0m/Aw6fghk6agWIDJj80A7DEQCsEcAtZIZ
         o8UrqF7K1TFJN179uuSmc1LWOOiMoEHOj6vRloG6p7iotbt0R9Xmkd3y5+GreRf65WO+
         ujyUJZKPdlmrRSHe87ltd8F4DKSO3lnSdrSLaMo/1LYUKS+ttBZ0LLKGBhFiGUWFN/hV
         L5TeEhr8a7+Cv4viyjqA+eFdGCutMwqmRfFqD/bpyguKC3QO3zXF4e1zl/MSm3BDAXKe
         JTrQKASR9CODvt3JKoo+Pb8Ks9g1UYllSM7sfmIjc6llvs7EJUFG+8QWR44o6U18YBhG
         w7gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=pWvSLP1WxF8yJq0CNCIWrsEahi/aazph8leWknyqaLg=;
        b=NxLXSkbgyphltjAtpZnnkGiwEwYD4TTZjAlO+tj1AXtHNR89L8EiGYQuMj0WF2D2V2
         v9XdiEMpF5JF6cNhPi7UyD6qKdeM4ZSti4NyidO9sfczaXMNsxb94GfSiQ75V2C2/GKW
         74izJgTxwnLdfnhGJxeSQbdgQW1dReEdYv4JLGsDt6gPdaNPxohl7ETEhpxs4jq70O+y
         gynWAY/LdlGrTZOccEbel4Lk4Ld+5NHc5lhineVhJo6QWssdACL8k5zdqLOWR5BmEJnE
         cq123rjruI6q/KTrhWq7OoK3fFqQmoTJj1h9bV6iLahuPj+N20Fq+F4BJ/jeLDvUhmJ5
         /wuQ==
X-Gm-Message-State: AOAM5339iLdIJiQlR+i7gm+r4Cus6MzsZEaH1iHigt7GH0dV5y86Z0SD
        qZkIH56aDClhjCSUJseSVfc=
X-Google-Smtp-Source: ABdhPJzB0t835iGOzU9KC2vcTVY/tT22CnlLNCIcYrJJSDPat94+1/Momk1bhgVHiBTzKDSYnS0w2Q==
X-Received: by 2002:a05:6830:1bc6:: with SMTP id v6mr759267ota.33.1610401937507;
        Mon, 11 Jan 2021 13:52:17 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m7sm171532oou.11.2021.01.11.13.52.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 Jan 2021 13:52:16 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 11 Jan 2021 13:52:14 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/38] 4.4.251-rc1 review
Message-ID: <20210111215214.GA56906@roeck-us.net>
References: <20210111130032.469630231@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111130032.469630231@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 11, 2021 at 02:00:32PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.251 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Jan 2021 13:00:19 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 165 pass: 165 fail: 0
Qemu test results:
	total: 328 pass: 328 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
