Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 295044C3A5D
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 01:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232358AbiBYAcl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Feb 2022 19:32:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232278AbiBYAck (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Feb 2022 19:32:40 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C53AA1B45DD;
        Thu, 24 Feb 2022 16:32:08 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id q11so3337737pln.11;
        Thu, 24 Feb 2022 16:32:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=tKC1TRHCBri+KzcoCYvPSpdvCg/HdwcBnsM6kDgfriM=;
        b=aFvL07xt/0stKeZefxUZbUC+5wQ0c2t8VfgbSdA4KnIJogwafaubJUI86KN4/FvFV5
         jbLhM+LrJv3ypnussHBfpu7uj5KI0PXVQ96Jdo+lCX3ypLIHQGZHtAkyVdAh4mtCu2qS
         ap4TAiaH3AgnoAQmDOleF4kCeej300au8cAl/UdmZr0lqIgLVI2qY4xeiFfraLkMfPy+
         3rauidoZEYE8aGNlxrQXELwdFr9QiuiKZh5bLLIvF73t45sBCn4jewpG/0Te1MH9Hphe
         o/sRG6BxKY9eG6wcyZ3QNsOS/fLPbBIUJS5HWzi/+UPcL9L4idltFRILXZRMw5LpG4at
         ebhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=tKC1TRHCBri+KzcoCYvPSpdvCg/HdwcBnsM6kDgfriM=;
        b=b993J+MUOCdsdA+nS1VKIX/OClj8gche/Wk7PbQ9WeRroS1Xcm+3khHo6Fc9RCuWur
         pAL90ZyXLV1nzgClSeJ7kgkpm1CAF6yba5n5hwrAESTcDd7re5BArrfig1j8W7NMt10b
         Uy2QkiDxugL1+SjZuXHp1wwesuTt1GNz3A14I2ECcl+dxrxFqMiGmUcb+sN0wIWnrKZL
         VGbYRarRCIv4djNzBRfQlnnaa04rYwSg3RrkFeqA2PfaNnaxcIJwEDdIKwwKT0zllE5d
         icjqE0GPLmaiMrEHrfBupf/TlqPwwpU0/CeXCrT+jgbFRQR/TRipwzSZ8pXW/TBbFbtU
         XM4Q==
X-Gm-Message-State: AOAM530Gwwmsp07+wvWvwJV0IboDd60GtZv/38ZrezjvngFTl+a40mb9
        EqcbpoP9qW50J9r4mChyMSDOlhSrCi4=
X-Google-Smtp-Source: ABdhPJx6JkQFQ7K41lpXb/O0ach2L1AgRseaw/gapGt3TSCEZRFc8m8HvGMfvjmlWhxUObOSXiOjgw==
X-Received: by 2002:a17:902:f701:b0:14d:7cea:82af with SMTP id h1-20020a170902f70100b0014d7cea82afmr4868065plo.71.1645749128161;
        Thu, 24 Feb 2022 16:32:08 -0800 (PST)
Received: from localhost (115-64-212-59.static.tpgi.com.au. [115.64.212.59])
        by smtp.gmail.com with ESMTPSA id g28-20020a63111c000000b00374646abc42sm602400pgl.36.2022.02.24.16.32.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 16:32:07 -0800 (PST)
Date:   Fri, 25 Feb 2022 10:32:02 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 2/3] powerpc: fix build errors
To:     Segher Boessenkool <segher@kernel.crashing.org>
Cc:     Anders Roxell <anders.roxell@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        stable@vger.kernel.org
References: <20220223135820.2252470-1-anders.roxell@linaro.org>
        <20220223135820.2252470-2-anders.roxell@linaro.org>
        <1645670923.t0z533n7uu.astroid@bobo.none>
        <1645678884.dsm10mudmp.astroid@bobo.none>
        <20220224171207.GM614@gate.crashing.org>
In-Reply-To: <20220224171207.GM614@gate.crashing.org>
MIME-Version: 1.0
Message-Id: <1645748601.idp48wexp9.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Excerpts from Segher Boessenkool's message of February 25, 2022 3:12 am:
> On Thu, Feb 24, 2022 at 03:05:28PM +1000, Nicholas Piggin wrote:
>> + * gcc 10 started to emit a .machine directive at the beginning of gene=
rated
>> + * .s files, which overrides assembler -Wa,-m<cpu> options passed down.
>> + * Unclear if this behaviour will be reverted.
>=20
> It will not be reverted.  If you need a certain .machine for some asm
> code, you should write just that!

It should be reverted because it breaks old binutils which did not have
the workaround patch for this broken gcc behaviour. And it is just
unnecessary because -m option can already be used to do the same thing.

Not that I expect gcc to revert it.

>=20
>> +#ifdef CONFIG_CC_IS_GCC
>> +#if (GCC_VERSION >=3D 100000)
>> +#if (CONFIG_AS_VERSION =3D=3D 23800)
>> +asm(".machine any");
>> +#endif
>> +#endif
>> +#endif
>> +#endif /* __ASSEMBLY__ */
>=20
> Abusing toplevel asm like this is broken and you *will* end up with
> unhappiness all around.

It actually unbreaks things and reduces my unhappiness. It's only done=20
for broken compiler versions and only where as does not have the=20
workaround for the breakage.

Thanks,
Nick
