Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D278B413B64
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 22:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbhIUUdH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 16:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbhIUUdG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 16:33:06 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3439EC061574;
        Tue, 21 Sep 2021 13:31:38 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id c8-20020a9d6c88000000b00517cd06302dso185261otr.13;
        Tue, 21 Sep 2021 13:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wFM2oJMTd+sQryv1Ke97NRB2B/H0jR0JESJji/oXm4Q=;
        b=j6HKASBW/6xCb1HM0nAbauptVI01GrchUBFjqYbbOXglilEdpW6IlSQZBei/4UpsOE
         2YEmXkOGRu/neXmcW0y6qO3ulm0GW5NS1CmR1Ioa3b0BFiQzP0SWboFMf1NaYVTj14ey
         yqKOrgOdAApQgy0fWCoLrcYsj+ugo3t2HD5eabXnAaYgP7IRhGDHhRbXXIrR9ca9kFUe
         mGr/PPxS8tT5eCI4LTCy8beG5+LadvizaSiVkmI0trnwK2TVONQpTiFdYeZUIqdqIzw2
         V76KoSKJ6qEkzxLA7SU49qy4dmbObILwKEcErv3wCYpn8+6k8mDS3D0lY6CdR4gGAgBq
         60ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=wFM2oJMTd+sQryv1Ke97NRB2B/H0jR0JESJji/oXm4Q=;
        b=KVP2zYWAqbbMINEi/zvE8XmRUz+ApLdk9aSO5Tcu01XmAflFeqb+Tt5FcwZQr4N1B2
         uj5TWlGX8FkOcnSGl44rjy71pbPQLvlRF5WD81CR+H0JMHvItellYxXP097isoBj3gcv
         ubnOxUmMJ6Z53kWiF1uZxKiXS70m64ExrjmITtYVKXLZ2zaZSp1DTj+TspjdAhbHduce
         ZR+UWb07jPGY+z2fX44MTMNif1ja9fx4LU++rv8F3KwfU99hgyDDkjSsu3r1tlN9W5X7
         5eTQCFUHrEGapo9HTx9mrj0X9u6xVxzrlLfZws5nsNhTR9dI+BAwBBSc6QMTXV/qB4Aq
         HCOA==
X-Gm-Message-State: AOAM532ZCHZnxDpq7/42R1BRG042TRrzFh3P0OIEmkeoMq780Hw4jYrD
        aZQJaEOCS6Z9BdLkI3/AwEvXFsYZ9cE=
X-Google-Smtp-Source: ABdhPJwMwbUFy6r3yNM8jlb3MUDibKmZJ390iGfBkJvNl6TQt6mYjE8UfBbRqlkB+m9m1epJyN0+tg==
X-Received: by 2002:a05:6830:314b:: with SMTP id c11mr27894342ots.169.1632256297557;
        Tue, 21 Sep 2021 13:31:37 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t80sm19836oie.9.2021.09.21.13.31.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 13:31:37 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 21 Sep 2021 13:31:35 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 000/174] 4.9.283-rc2 review
Message-ID: <20210921203135.GB2363301@roeck-us.net>
References: <20210921124257.592357088@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210921124257.592357088@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 21, 2021 at 02:48:59PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.283 release.
> There are 174 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Sep 2021 12:42:28 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 394 pass: 394 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
