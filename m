Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67DEC5AF2DA
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 19:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbiIFRka (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 13:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231266AbiIFRkJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 13:40:09 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F18FDF2A
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 10:39:42 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id b16so16144203edd.4
        for <stable@vger.kernel.org>; Tue, 06 Sep 2022 10:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=Le4pKiUfX2V5429pBsCeTh0hmRLKMdZrggyyLv3VnMk=;
        b=eqEySuQMpmkh8JGJxVsspGKYvMvcSuMxE9PP4vQy2gAX+m9+xUhDg8BP9wVmBWT4Yz
         F3qThfdyVZJjsxRh8B3mI7fkI9/imk1KkBJohynLcB4Vz5G5tgvMAz5OOzMaDLJEBI7D
         eR8vFGFfTcdIDnpOphs3mkDANVU0mPRawxBinGFHe/WyGqzoSFAEkaIpww9zEWBua/07
         26LQiI3HgBcQ2iwJs8yIIMLjfQg82Sfnn2OktR6pT1P4rF84YoT2La1Dk9BvhYWBSzay
         FHAF39MD0j9+6fuSLKTCqVt+fxZYlnVUpbK8Piv8xQdSmM0h9i3LLESRJrkXW4DEGeAc
         lE0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=Le4pKiUfX2V5429pBsCeTh0hmRLKMdZrggyyLv3VnMk=;
        b=NRAu+NVYVim26f/d1DboSMwyC560mzQpnDj+/tp/JUCmUWFWIpEu+54E4O9GPc3uvX
         DT7NQBluvQRUKfueoPrVn7EE+pm9wXzwOHy2xEB4WiDnROCRcDbNqRvh6ZdJXt1YM8wD
         M9sBYn3MjEEg38kZDAY1PPI2ufU26U2v3yTxTg/i7z6h8BlMtum41zzMt7PqSt5BG6CT
         CwpQ3igesYTaw0BOPUAIg682X33rjKQ04AySwQT5iapNf2A/tYnPjTfzDK261L8aIGMN
         SnYHq40ZhwDY7Q95wDQ8S/DV/9iTTCCZNM16Ou2FIopWi2SLnddoMvzmaGsbDN7dTw5P
         rMew==
X-Gm-Message-State: ACgBeo0EGxQIjgFaQmURYjD6aSjnVjRUDI0dOzD1fBVYQljMDpWJiZwg
        6yIGKb54tkmQ2gJECDoMSJrXc8AHfg34i9qmMG3uyzH+zqFuCQ==
X-Google-Smtp-Source: AA6agR78lnxum8NNCEqP8NWDwke/IhPeQ28hXB94IdpwJeUE2DdaWJLWed5Us8elOz29iW0rr/zpwKfv60fQfnmZUE4=
X-Received: by 2002:a05:6402:254b:b0:448:92fa:3f69 with SMTP id
 l11-20020a056402254b00b0044892fa3f69mr33338342edb.316.1662485980754; Tue, 06
 Sep 2022 10:39:40 -0700 (PDT)
MIME-Version: 1.0
References: <166246409522325@kroah.com>
In-Reply-To: <166246409522325@kroah.com>
From:   Isaac Manjarres <isaacmanjarres@google.com>
Date:   Tue, 6 Sep 2022 10:39:29 -0700
Message-ID: <CABfwK11et2hfQkc538o-OF3mM1e0G=2JXSEUVaFt+ega6UV=Lw@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] driver core: Don't probe devices after
 bus_type.match() probe" failed to apply to 4.19-stable tree
To:     gregkh@linuxfoundation.org
Cc:     linus.walleij@linaro.org, linux@roeck-us.net, saravanak@google.com,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 6, 2022 at 4:35 AM <gregkh@linuxfoundation.org> wrote:
>
>
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>
> thanks,
>
> greg k-h

Hi Greg,

I've backported the patch to the 4.19 stable tree:
https://lore.kernel.org/stable/20220906172933.410698-1-isaacmanjarres@google.com/
I checked, and it should also apply cleanly on 4.14 and 4.9's stable
trees. Let me know if you run into any issues.

Thanks,
Isaac
