Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B28E658D98
	for <lists+stable@lfdr.de>; Thu, 29 Dec 2022 14:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233263AbiL2Nnn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Dec 2022 08:43:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233445AbiL2Nnb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Dec 2022 08:43:31 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE89228;
        Thu, 29 Dec 2022 05:43:30 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id x25-20020a056830115900b00670932eff32so11506096otq.3;
        Thu, 29 Dec 2022 05:43:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c/AKNkpjG3AzcQVd4ZQ2WSvobV2zMcJthzt1GCCuMa8=;
        b=lx51HzEUMKRJNqK+LwX1Y783CIcF1MdK99uBpWNybmnsDgUNqgcC9xnqH3vMjqvE05
         aJdGTrehGxkhMKHJHrHOpvGztuLhOx1mMSrACKXV0yRPlPwme+t2CGuvAsVbyTghEWtR
         DBZUPsZAgYbzfkGZwiXlIYlJNTltoRB4VKe0GggcTJJ+H8RSJkvMP/XznQ1zCx+BSkgd
         Z0DoPPkVZxFUGp46d0xkdgzJAqd+T+76DvozceDGkor1ZVJtHpMamoReswERHjg8JHHC
         AoW+pLmx7u5l9vIG6SuxneBp15snj9SpOBLqLNU0W8q1s/LHH26bwkOqaobso/CyN8I6
         OMvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c/AKNkpjG3AzcQVd4ZQ2WSvobV2zMcJthzt1GCCuMa8=;
        b=wvDYsq5M4khl+c5EgLCbXAfAzbWMnAf57qyk2xuGhC3TW8S1/GiD2bQdgQq/TliUaO
         pJrHNGAn2kanYGYxCVLQIQ8Yj3ZazXA3MSfgtbLobspZ+LT3XbYwznhLJn153YW4b5JB
         YWBOO8kJDDG+UkNFzsk7IZwm7+pFr1EYu9yVVstwiwr0FiGtiywcoYoucUyZG2ITWLlc
         P+JzjDzOmlHhaHGQcO/XymErEWf7o3A7azxY9VNZcI9fUveAtsGHb0rI/SZCO3RDP86l
         gaObfcJ96+SxjYIm9Bv300IWkrlsScL9TQUYS9c07a+faHOtQm94vWSr0H5sQATGD7Uw
         4rqQ==
X-Gm-Message-State: AFqh2kpjEOkR7WloFDyVGG8KU19Yo0mhp1C/tZXK50ZlZLjmufrZMKQo
        R+0E+QCF0ogV+6BKeaCb8ts=
X-Google-Smtp-Source: AMrXdXvdz3WgDc5KZ8RSpx3y8x+2pyRuWkgjB81V/gHbU5qzSVNz9Fk5odUxbxUXLOQiozcJJzEnVw==
X-Received: by 2002:a05:6830:611:b0:676:205a:605d with SMTP id w17-20020a056830061100b00676205a605dmr13867016oti.37.1672321409656;
        Thu, 29 Dec 2022 05:43:29 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m12-20020a9d400c000000b0066e80774203sm9169354ote.43.2022.12.29.05.43.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Dec 2022 05:43:29 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 29 Dec 2022 05:43:28 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 0000/1073] 6.0.16-rc1 review
Message-ID: <20221229134328.GB16547@roeck-us.net>
References: <20221228144328.162723588@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 28, 2022 at 03:26:28PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.16 release.
> There are 1073 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Dec 2022 14:41:34 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 153 fail: 2
Failed builds:
	arm:allmodconfig
	arm64:allmodconfig
Qemu test results:
	total: 500 pass: 500 fail: 0

Build errors as reported.

Guenter
