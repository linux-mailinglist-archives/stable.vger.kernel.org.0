Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82DF0607A63
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 17:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbiJUPWa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Oct 2022 11:22:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230312AbiJUPW1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Oct 2022 11:22:27 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E6912793EE
        for <stable@vger.kernel.org>; Fri, 21 Oct 2022 08:22:26 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id f9so2618084plb.13
        for <stable@vger.kernel.org>; Fri, 21 Oct 2022 08:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gae0iqrJma0ubJGx+korPq/UL8n+mTcx7+m98ESw/To=;
        b=cbgNtDowPMJuPJfSo6xwdnR0uAuoLCd7NJHfHfwL+xL0hVCvo0guTQR3xwvwxTktwQ
         txdvC2CUP9dP/VhRu9jrET1iuRz5vzSrxQLQy0yzAtWTTxYxF00V1ZIDYviyJUshpkNR
         XUjqevynxeCBKfE9jUZ0F4uOdgefYz+lIDGDDWFnJDKS4pqOFyHAqxMT9zC9B9dfbUCB
         jIwAn7T9Ghka8Q0UIxSDYG5riePV8k3mk1PxcZyspflp8vTKQxgwezN6wPzJhJo6IvI5
         GCYtildMShVVkqSJuRveNB4wPtmCGftN/5K/wrC0Yum7LM9CpT220MZZi22N5w1vprXw
         htEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gae0iqrJma0ubJGx+korPq/UL8n+mTcx7+m98ESw/To=;
        b=6Xg3Gt4eyuCh2DYE+x/kxeRakx2A2daseUsqp/E6TTha9/RFNgiJlQXTdeXtCil8Q6
         j/CZhodmplIMjl8uQ8CJ1YnpiVz39qnk1Zp1wjm3trxVjB+V558iAugnkeUpItG8eX7T
         i873oQDbP3ozutohNeyHnNYCpXHyeecNO+tVl6bFC4LVwTegAtUB7kqUZX+gAf2XaaNy
         fdu2EcYBVMBuCy3e1k7nGw3sm1HNEFz3ej697uah+aBNXfeJWSCoBkoeWBS49U3dZGmF
         PKzmVgZB9Hq4QzKlrCKhAAfXENMQijKcPuGdhazRcNxNCO2D9T+UO/159Cpi8+GMTDcE
         D7aQ==
X-Gm-Message-State: ACrzQf1rXFP/+SYu4x6tylCVoI9yUS6YSM2wnRVwwWPt42jkMd3oj71Z
        5CxWygxyGVVNP3Rffg2VLN83hTWAZy+TiJRYB+c=
X-Google-Smtp-Source: AMsMyM4Qwfi26Q+Th6k+9ggLBN2uQaYhLWO6zL5lT0seOdIKsZ8OXnN3EVBVxwWnqLixSbfalwlmJYEUI/+9BfVjKEY=
X-Received: by 2002:a17:902:8491:b0:183:c3d2:2112 with SMTP id
 c17-20020a170902849100b00183c3d22112mr19763974plo.133.1666365746335; Fri, 21
 Oct 2022 08:22:26 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6a10:8a50:b0:2fc:9a3a:5cbe with HTTP; Fri, 21 Oct 2022
 08:22:25 -0700 (PDT)
Reply-To: fionahill.usa@outlook.com
From:   Fiona Hill <lori.j.robinson.us@gmail.com>
Date:   Fri, 21 Oct 2022 08:22:25 -0700
Message-ID: <CAO0nU=eJwnFxYKOO1T+SkXTOu-wspmB1Pc-esthtxW64TxYW=A@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 

Hi, please with honest did you receive our message ? we are waiting
for your urgent respond.
