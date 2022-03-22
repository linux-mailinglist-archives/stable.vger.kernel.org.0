Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1A64E3B0B
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 09:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbiCVIrB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Mar 2022 04:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231713AbiCVIq7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Mar 2022 04:46:59 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FCDB4665A;
        Tue, 22 Mar 2022 01:45:32 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id mp6-20020a17090b190600b001c6841b8a52so1872297pjb.5;
        Tue, 22 Mar 2022 01:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=q52eDajcdb7Rqfr+TDj+rYXShCii6o0JcJYCHCQrCGw=;
        b=K2ABBwDVUHxHtK2uHgGcfUS7M4wmkh4de2tKP2a9Xqbf/z/ymA6z8qVnrdmT4XMJbx
         5PgcYEURK58nvh3DLvkHm6BDLwvprLyMFNfPkCFuNkxuoOGZErPi7uZUf6TvMe3I/TiO
         SY/+eZXzVVQdQpQ0LuMM/KpcOA+1frwC2xqx0SMEeYnlNfH2tEYCYNmiOCF862Cz2wPg
         RiWi+RxmTo+AZUCD/XWfBIlCEHHyNafSDNLt1wK+BO7kaotk4arfVWI/929ZRwPIQvSD
         Av+9LRdQFxIFwRzsw2PhyUbQ5ewRwVuZ6JYVzI34ZQCGXL1vTPLJW7QL9JRHSC+GxKxU
         qbXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=q52eDajcdb7Rqfr+TDj+rYXShCii6o0JcJYCHCQrCGw=;
        b=0B+i5GGa+dzqXYWhh9MOQPc40n9dtwUVbT2GSAYOqnazUYJE3jI3i2VNf5ZpUfT6Wt
         pnxmgLHhat9WwU+cDHnjXJ+0hKy/nF1DONZn7of8ralUCjnHbuAkrZr2ENFedGtQ89lv
         GJ4WxFtEWH4XrTz6m2YCcsuX0pNfBOp+SHsUOTjgFVVRVrQtZlOhRXiVygm1tj+VzHF2
         U5yYAISyQGRrkoNSuHQeqbYoKSqcQoC7EMlbTIiuHJNPmMra8fF9iZPpY9JBZrqHHiMM
         obxpfSMiDxOa2yQudJpFP8atQmTxVaFENDwBIi9e/OCgzpPwWceqS8t7tNLzBWC+OfHp
         4Q4A==
X-Gm-Message-State: AOAM531xPEuSHu9keu0qAQbv9ss5us07hziYyvAOtvFOdY/KCeVw7YST
        pacftHevhY4vIOA2V+dWtzPGtXB3HiLIH3rC
X-Google-Smtp-Source: ABdhPJws0PsQepO6L48R2qUzhyAhVI7bVwQlm0yX1tw8IO51B6YBn0ZbfsDGV29mhR7CFTfLgJF6qA==
X-Received: by 2002:a17:902:c713:b0:153:f75d:253b with SMTP id p19-20020a170902c71300b00153f75d253bmr16949319plp.99.1647938732164;
        Tue, 22 Mar 2022 01:45:32 -0700 (PDT)
Received: from [192.168.43.80] (subs02-180-214-232-13.three.co.id. [180.214.232.13])
        by smtp.gmail.com with ESMTPSA id f22-20020a056a0022d600b004f7a0b47b0dsm23918412pfj.109.2022.03.22.01.45.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Mar 2022 01:45:31 -0700 (PDT)
Message-ID: <70cc1b0b-0510-71da-aded-2134cdc22f6a@gmail.com>
Date:   Tue, 22 Mar 2022 15:45:26 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.15 00/32] 5.15.31-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220321133220.559554263@linuxfoundation.org>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220321133220.559554263@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21/03/22 20.52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.31 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, gcc 10.2.0)
and powerpc (ps3_defconfig, gcc 11.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
