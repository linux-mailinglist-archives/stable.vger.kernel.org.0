Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4CF350FD40
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 14:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350069AbiDZMn7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 08:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350088AbiDZMny (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 08:43:54 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E85915F5AA;
        Tue, 26 Apr 2022 05:40:47 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id z16so17850524pfh.3;
        Tue, 26 Apr 2022 05:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=yD7e9mPWeNwo1vgL89bG3pSg2Dekc+TvmVsazxgc/xQ=;
        b=GnbxG5lHExJVNlDP+xzzDlUmG5m8kM2lnHSyteFhSHuHmpvLor+hykPvI88Ozca2bT
         VJsDsUomaDNoDRz/VtOzCjG/S91wN/bnLQU8ay8+PyylBsG0a0DoyukUNb3/ScorOh8E
         lvNdkOuaBkw48w94VH3S61M1BI0ruUpScv4/3bK0+55k1HhwfZC1sdGqEznzkYYu2e5y
         0TjpNn2RhmZKHJlDu4Qlc8ZprjifkOaqcCdteN9ZnRdKvkFtklPpU3i8p1syKgIU1bjB
         eVEDh8n9T3T8Fp8LX2Z/1S6VkrdAC9QTatPw6NZ/lXf2YVRUOwBrNp2flzFbpWTkFwgZ
         s7zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yD7e9mPWeNwo1vgL89bG3pSg2Dekc+TvmVsazxgc/xQ=;
        b=dHq9xKz02sU+ib7v4vjZaW6lKxQdPUByZI+EuJmsc9tKd25L7fWUwXkZS4HzmpDXWr
         ZWK1nSszTch9F3xSQ5/3O6v7RvibD0BqZwzlIBfA1OOtjY/IvgFoQil1/Pdg5MlqP+LP
         V/CJjV4dtwQFSz0P2om4KwU21QGecnxxC5cVpHlZgcVcDsW42wmLxWG/ZwXZmn8o4ty0
         cDPe3HrjrPZkwde49WiFRs6auUjf/4yKjHtNnH5QL1/gGV4y/mfU9Kc6uN6J4S/cCSZ9
         5U1q7WME7I6RgmWvyeqILaqI2hcQFE/KoqvA+AlJFJRbPip8b+MlXvzje3hM5pVv2AUt
         SIFg==
X-Gm-Message-State: AOAM532emsBtvim/pJOsAqUpdUANRWUNd2bpjyEsnquCiktzdJArPel1
        ABH680ogLR123EGO54GeQEqBSOGH7t67AA==
X-Google-Smtp-Source: ABdhPJxQpQBnfySbDernbtM/2zvLb6OSYK+avT5/SNEuSrqQE/7Jv9ZFk6Gy3eDnWfCPcZ391s1lEg==
X-Received: by 2002:a05:6a00:1145:b0:4f6:3ebc:a79b with SMTP id b5-20020a056a00114500b004f63ebca79bmr24461635pfm.41.1650976846536;
        Tue, 26 Apr 2022 05:40:46 -0700 (PDT)
Received: from [192.168.43.80] (subs02-180-214-232-1.three.co.id. [180.214.232.1])
        by smtp.gmail.com with ESMTPSA id w129-20020a628287000000b0050d4246fbedsm6798183pfd.187.2022.04.26.05.40.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Apr 2022 05:40:45 -0700 (PDT)
Message-ID: <9b428d55-322b-5685-b336-4bd71b52a73f@gmail.com>
Date:   Tue, 26 Apr 2022 19:40:38 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] KVM: powerpc: remove extraneous asterisk from
 rm_host_ipi_action comment
Content-Language: en-US
To:     linux-doc@vger.kernel.org
Cc:     kernel test robot <lkp@intel.com>,
        Suresh Warrier <warrier@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Segher Boessenkool <segher@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220426074750.71251-1-bagasdotme@gmail.com>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220426074750.71251-1-bagasdotme@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/26/22 14:47, Bagas Sanjaya wrote:
> Link: https://lore.kernel.org/linux-doc/202204252334.Cd2IsiII-lkp@intel.com/
> Reported-by: kernel test robot <lkp@intel.com>
> Cc: Suresh Warrier <warrier@linux.vnet.ibm.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Anders Roxell <anders.roxell@linaro.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Segher Boessenkool <segher@kernel.crashing.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Fabiano Rosas <farosas@linux.ibm.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Alexey Kardashevskiy <aik@ozlabs.ru>
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: kvm@vger.kernel.org
> Cc: stable@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>

Oops, I forgot Fixes: 0c2a66062470cd ("KVM: PPC: Book3S HV: Host side kick VCPU when poked by real-mode KVM")
tag.

-- 
An old man doll... just what I always wanted! - Clara
