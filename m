Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B3D433FC6
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 22:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233156AbhJSU2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 16:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbhJSU2n (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Oct 2021 16:28:43 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA3B2C06161C;
        Tue, 19 Oct 2021 13:26:29 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id l10-20020a056830154a00b00552b74d629aso4307187otp.5;
        Tue, 19 Oct 2021 13:26:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xIK9LskpeEzLPX5RlNxkqNin3zQ5MnZfzX+PxC99Pj0=;
        b=o7Dj6BbAXClqw19Der+hYeCAeyFSZVQjN9Q57v/aTgL029KwXaAOwGFCPjfH0vQI0t
         BPn+ciNQH13unO7EHX5Dp6lOAtGB4YKW9Msz5BGiLcRbtiIycCWIqzjKs+ogzOJC7Rsr
         obX7cTjCYcAixBusSvMQqNYbywj5g2qC6XVae9LHUVX1futg08CwWBtbW3HNAhIBWnkF
         xK4lnKr0vyw8FV0gZ/AL9wInw6d+dO897doRZw+6POn34IWWlZqAFtUZUrRe/CYF+c7l
         HQjdHhEyzORyV/bDI7WAzjiTZAU1vQ+5zan808ScKieJnmuv+UGUjsff9gYzswVCTTt4
         wfXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=xIK9LskpeEzLPX5RlNxkqNin3zQ5MnZfzX+PxC99Pj0=;
        b=jSJVnUQNoe6SWCpiHFpCyuNxKNnDkpejZPhEwK63z1nieyyIUQ4gSNgtYoxcAY5CkF
         eScT32knw0yVBlAqqtFOasazCQMZF8vvlnAh/IlNxlIhI2y7p3mDAUaGtsJXN8nlVzTF
         S7+tC4xV93Y+WZYBaUFxYV42D7csqDodafAefK0O7CPc+PnWIz4AuF13Ir3vGRVfs4k3
         MgBpB0IO5zJW44ZAG6/wegdVFos9KvMAKFFpa5n9fF8mwhxpiVj05IwJC6Wmop5qTj0m
         ZVPxsH1NaDIEuJn3ItRYheqD8QGiHbcjiseDloij9eO+yRr2/8riQnsttdEHhrnX8edp
         Kr2A==
X-Gm-Message-State: AOAM531gyEwDvXwF8cuAWSOa8kglIP335JLtRB7oqWp3Uur6saclNbtB
        CNSoGF8bNY08wYFX1nMuHXI=
X-Google-Smtp-Source: ABdhPJwFRA94zhhExj5o0MMhMka88ZkH2MvNMNVdcjtdyv8gkLhEod8FW021nz/N0m+855AEykE6RA==
X-Received: by 2002:a9d:64c:: with SMTP id 70mr7075712otn.59.1634675189354;
        Tue, 19 Oct 2021 13:26:29 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o2sm25849otl.34.2021.10.19.13.26.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 13:26:28 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 19 Oct 2021 13:26:27 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/68] 5.4.155-rc2 review
Message-ID: <20211019202627.GC748554@roeck-us.net>
References: <20211018143049.664480980@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018143049.664480980@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 18, 2021 at 04:31:04PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.155 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Oct 2021 14:30:36 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 439 pass: 439 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
