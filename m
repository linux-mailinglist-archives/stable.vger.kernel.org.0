Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD965549D43
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 21:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234621AbiFMTSN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 15:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234586AbiFMTRl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 15:17:41 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8D4B3123A
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 10:14:27 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id l4so5031048pgh.13
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 10:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=q3ll5jEP2t2CsOV5mJ9Lm/eNFB2SHb8fwGUCCDQrsO0=;
        b=F9Dmyjwzv2BEelHz7PJex+FuAbmYcPkwAbOQWV7DkB6t+QTRrVMnlcX6ZYZwZOjH8E
         9y5wWh+yhRfIpe69TakkGIbElqr5S2LK6a9iqYRNZAq85N9BEYBPmuaqLwdKgBO5mXU1
         uFtWLQc+4ZR54mskxEeTmr1fDcj55QLyl1l8o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=q3ll5jEP2t2CsOV5mJ9Lm/eNFB2SHb8fwGUCCDQrsO0=;
        b=iKUbO7X2gKvG43Geoc5HflOAbiTvaBlVmPGmHIgdR+PJBqEbFI8+98q06u4O1RX10C
         0z81CQ7beBpHR8yMgfgjYau0XxSGovNcE4rJwmjWsR+sN9zQgOamT39J7BBvsNgLiX6U
         EoWendboIF6pH0pUtDd1AzVMMWUEbF1pzBR8i4PX+LWY2wx1XBuk02Qz0fh+Aeg4IP0V
         Q45hSb8+1CEZHkEDUQ8gifem4saGTXV2UK+ikn1Wk2Ea8Et7hxGh0ZjeVLAJdvLowmg1
         sQH/yu6C4jwSmHS5DZ+lfzMnhPQ1mUSPd+qN0zP2vgaD2+vw8nWx7GfNVQZIi+vFSsE4
         JOWg==
X-Gm-Message-State: AOAM531hEbDsVLGORcblqdjupjOC60lBuYe1S1y6pXc6AMZ4IZ8C/330
        K8WCKSSeUye7SqHhKio+oAThHCk66oJi4g==
X-Google-Smtp-Source: ABdhPJyID9xIthmByLOSbmLQ+hZGxlQijKuPUli3jnD6NTly8DKqdxatMXFTWRIwuHQv0whCqlLxfA==
X-Received: by 2002:a62:140c:0:b0:51b:bd14:6859 with SMTP id 12-20020a62140c000000b0051bbd146859mr346192pfu.28.1655140467272;
        Mon, 13 Jun 2022 10:14:27 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id iz3-20020a170902ef8300b0015e9d4a5d27sm5407597plb.23.2022.06.13.10.14.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 10:14:26 -0700 (PDT)
Date:   Mon, 13 Jun 2022 10:14:26 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] powerpc: Restore CONFIG_DEBUG_INFO in defconfigs
Message-ID: <202206131014.B0552BDB8@keescook>
References: <98a4c2603bf9e4b776e219f5b8541d23aa24e854.1654930308.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98a4c2603bf9e4b776e219f5b8541d23aa24e854.1654930308.git.christophe.leroy@csgroup.eu>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 11, 2022 at 08:51:57AM +0200, Christophe Leroy wrote:
> Commit f9b3cd245784 ("Kconfig.debug: make DEBUG_INFO selectable from a
> choice") broke the selection of CONFIG_DEBUG_INFO by powerpc defconfigs.
> 
> It is now necessary to select one of the three DEBUG_INFO_DWARF*
> options to get DEBUG_INFO enabled.
> 
> Replace DEBUG_INFO=y by DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y in all
> defconfigs using the following command:
> 
> sed -i s/DEBUG_INFO=y/DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y/g `git grep -l DEBUG_INFO arch/powerpc/configs/`
> 
> Fixes: f9b3cd245784 ("Kconfig.debug: make DEBUG_INFO selectable from a choice")
> Cc: stable@vger.kernel.org
> Cc: Kees Cook <keescook@chromium.org>
> Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
