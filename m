Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C735626CC29
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 22:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728504AbgIPUji (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 16:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726805AbgIPRGO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Sep 2020 13:06:14 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D471C0611C0;
        Wed, 16 Sep 2020 10:06:04 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id n2so8942505oij.1;
        Wed, 16 Sep 2020 10:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lFqd3lR855O3OJL/2i1GXW9OFx3k1PKlTbd/Qc1Stn0=;
        b=MgpyflVGVmvOehzHEf6qX/mRoKan1mUyVqURLkR19hnk31ZzXTgiYl6CoRLtYC9iXP
         CT4oEZMGmD45ZslSXebgJjRjH1lE/FJ4/D04jRPxx1rBf3uf+I8hWGEM62ISOCbIa4Hx
         228aacyoIljakbkDgbjIHHtoxTMdMEGHLzWA9gOMwd9LRoY/lG0gHOPGr7KkaTQWmLkL
         xvrptvFfF0o76NRYsA9fpD0Qq47ay1EvpmahC7i9Mffydu5Ao2HDc0kh/GqRjWPXRGZl
         mnlK0K7j2TAZ5tpYA5xnTDenXIouYrtMlvooeR8TdFYFbaG4o3LYic20aLN3Q6dWA0cs
         NbfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=lFqd3lR855O3OJL/2i1GXW9OFx3k1PKlTbd/Qc1Stn0=;
        b=CFsakiYU4Lbn1QCDNX0GVOoPd8r9DJISudaI584WB/J98CCLZUBkVDmo27rR5nWS2M
         hPDn3ocrOk+oLlosCnEfnDNW8XpRMsXKjs+YkldHrp6ZBJ6i36cuIJ5i/Sanp4ua8XYc
         6yFMOs5XVWARu43IeTXO1Tnut+D/hsZ61ylfbg6GAae937if8ft2AqsWyapEKkQJUVJl
         sy+VyMWS5mD439eMhIhTb7aXVJdOpfx4KLz0VRYk8HBFiELlzMvdq5Bawsviseh/DBDR
         BdG4ELq1RZAxZ4q0PwHnlttofnoFgYgiDVE7YLq+hMHMzdYa86/xUBdYrdgjUPt/GYm5
         +/iw==
X-Gm-Message-State: AOAM5321oSUYJRB3mmaXrElAtbhZLbIecXX+gwhY1LRjzvMmUaPNaVg9
        fyhuJgvzNRoglQpxNxN4j68=
X-Google-Smtp-Source: ABdhPJxgo9sTR8/dHKoJLXUuoqzosTPzH6bSaqynQa7oqCHdVujfIAoNCTd9hy//85fAxMymD+vu1g==
X-Received: by 2002:aca:1312:: with SMTP id e18mr3819913oii.19.1600275963632;
        Wed, 16 Sep 2020 10:06:03 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d63sm9898760oig.53.2020.09.16.10.06.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 16 Sep 2020 10:06:03 -0700 (PDT)
Date:   Wed, 16 Sep 2020 10:06:02 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/130] 5.4.66-rc3 review
Message-ID: <20200916170602.GB93678@roeck-us.net>
References: <20200916063531.282549329@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916063531.282549329@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 16, 2020 at 08:37:45AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.66 release.
> There are 130 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 18 Sep 2020 06:35:01 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
