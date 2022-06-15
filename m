Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2A6754BE92
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 02:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbiFOAJo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 20:09:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbiFOAJn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 20:09:43 -0400
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8F92CDCF;
        Tue, 14 Jun 2022 17:09:41 -0700 (PDT)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-1016409cf0bso3455163fac.12;
        Tue, 14 Jun 2022 17:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=QAkhBCaSmCTnJ/G08Ie4opUXvHOSHSllHpSvWxOON4o=;
        b=nlFG/To4e5qC5USscaSig4NcableAJXSHOyqNJbsBCIzl3s4O6rn7oxueDKybRfCeI
         DsSddW6c0qGl98WmaoAfTipKJ17Tso/hAfHBKhWf4OSPmpe9Jp9maFvsun6eKnHorRD0
         nFKKshgPReKwDjjgrmw8wupAVTD9tvXC45mAH/51WqaNsvOrI9e1T80Kr8eAlqo+9f63
         gMBl83PqztDkjT5zFHhMlUZ2Y8VkoMQ/I78g+kqXhJi1Uh3y3DN/+AZLIf+TCDQGtVoX
         0VZHJPKQnEFvKErEwAkCwpYdAJSAiF9UoXaJY6xkLVrIrPuIAa7cpDvn2U5YBzqzJsrA
         jUXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=QAkhBCaSmCTnJ/G08Ie4opUXvHOSHSllHpSvWxOON4o=;
        b=PZBsSjTEWUckT4Wwm2ZmeMn7r9I4SJK3pN6KDfeS2vMKLOVIRA0AsXcK4qjiHq6yhI
         bR8NvGsUE/srROhx7F5YrOsTMETAeWU3idYeGYZt31eEHeDkt0iXX8QFexFIm6kjQwrW
         o7rMWaBH+qKV6vTGgGWWigwbuyvLt6ZQM/RNozzFbbE1zTImATLAbG9YIMjk3kJFc7Ap
         O779AT/haWDnY0rbs2oUFW209UhsNrmr6kZEXrmgpMlTSv4zwRfrWZUT5sQt9njtfVZY
         bgp7hWyTblLUGh3IQp3RCUkeEXenQOl9gMJImshKN5sCGg3K5pfCLeU+nWUknDtvHksS
         XHUA==
X-Gm-Message-State: AJIora98gkTW0reao9RaSGx/6sRtvpwyTiAK8mbtz6d4+duXGNoU8Q5a
        NEyxfnyj2khf40xcviLZoxuRokCSiRd++A==
X-Google-Smtp-Source: AGRyM1uMI1DnI2AnVu8vFnEvTpbVL2UYrn2VlzANy2JW6VHGq7khQA3r+kGTDKeMTI02bawptK3DuA==
X-Received: by 2002:a05:6870:f587:b0:f5:eee4:d01c with SMTP id eh7-20020a056870f58700b000f5eee4d01cmr3946490oab.117.1655251780266;
        Tue, 14 Jun 2022 17:09:40 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id o18-20020a4ae592000000b0041b5d2f3c92sm5761503oov.24.2022.06.14.17.09.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 17:09:39 -0700 (PDT)
Message-ID: <62a92343.1c69fb81.309d9.e116@mx.google.com>
Date:   Tue, 14 Jun 2022 17:09:39 -0700 (PDT)
X-Google-Original-Date: Wed, 15 Jun 2022 00:09:38 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220614183720.512073672@linuxfoundation.org>
Subject: RE: [PATCH 5.15 00/11] 5.15.48-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 14 Jun 2022 20:40:29 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.15.48 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jun 2022 18:37:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.48-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.15.48-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

