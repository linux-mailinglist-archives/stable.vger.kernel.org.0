Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 450C6656CA8
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 16:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbiL0PoO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 10:44:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiL0PoN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 10:44:13 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21381FE4
        for <stable@vger.kernel.org>; Tue, 27 Dec 2022 07:44:12 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id n1so14103780ljg.3
        for <stable@vger.kernel.org>; Tue, 27 Dec 2022 07:44:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=asgJld1GIlljSVbSSexFqBPIeAhrmv47MNF0MFr2hZQ=;
        b=OTEJhua1IWf99SeczX8XA1O7QbRIsWfQPrxInCpxs+vePkLeruvfnMrhq+a3JV7+9Q
         h5rIqxh5LDsEr2jt5enbloAxHCnk/nym+MqvJOatR4hkkU+3UJJErRZEF5IgJ7edYjys
         WYPEva/OUyPV4hdW86+ihxau/sXtmTKtYP2Ie1HbX2OJY86BUtfRIKbEqAX40hCcbENF
         RzibRPNF1+t2Tk6P+GPW7aXXoSQzBWdgjZt/yxkKA05rFpk2jwxugnQAbkwLQTS7qe5d
         znyuwwXINvzL1tn2nL2XH/kNRE+pKuOCfrqifQIMlKF/YelE6GnXXQiWV4RN60r5fAWa
         yMLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=asgJld1GIlljSVbSSexFqBPIeAhrmv47MNF0MFr2hZQ=;
        b=meOLuMKHOKSaq2kq0IKeNYroXnf0TEq0whjGW6vBGPPsYX6nBlErOFVBcEOVDbXN2E
         /UDcAEQb8gVbB6SiK1EOqNohQuIM7rtDR8Sn4zBT7iUHGyafEcpWVKPe/Xav7AAYHg+F
         GtvrgORPrnAPaSuMBJ5GkF+ZcALzYZzTgZmUYBi6TueM9vWlh9SqO4Vj49XL2mnuIQ/D
         tIt6CvR8zTLBtIdxk05vtLhrZXUX2/rdy1xYh8qy3wJR2Y6xVcSlzkPwhdMhrd0IRIru
         3xOxaqbsqdY95lkxXwo+CObUdVpsLuki36Ko7hEhDjN25FeMXbonG0/mqVEMtdXZ3CvT
         Bnqg==
X-Gm-Message-State: AFqh2kpid5ZpYkFZB1FNzn5S3iQhtaiZrcs9sMse3Iu43IFNQg/Cj0QX
        XKsAITalbe0YCOqdBbYdg2SZbjAUT47uEqDAGKA=
X-Google-Smtp-Source: AMrXdXsZ19fQjQsoDC91cZA0tHzleR7qYE1RBM4sGTIhEQJpV5Gu6Rby23k3WDJeHH6q2MiQrUOQuGiW7znm5GQADck=
X-Received: by 2002:a2e:320b:0:b0:279:c702:46f9 with SMTP id
 y11-20020a2e320b000000b00279c70246f9mr1349355ljy.164.1672155850530; Tue, 27
 Dec 2022 07:44:10 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6504:16cf:b0:203:6628:f74 with HTTP; Tue, 27 Dec 2022
 07:44:10 -0800 (PST)
From:   gates justin <gatesjust234@gmail.com>
Date:   Tue, 27 Dec 2022 12:44:10 -0300
Message-ID: <CAJPWxDo2Sp3-8hZD_9xADSAcC1DCg0L=mJiaNCCTXdgGY7d7WQ@mail.gmail.com>
Subject: WTS Available Cisco and Memory
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

Make us an offer on Original New sealed Box Cisco located in usa



C9400-LC-24XS
C9200L-48T-4G-A
C9200L-48T-4G-E
C9200L-48T-4X-E


WS-2960X 48-LPS-L New sealed box Cisco Qty 30



32GB2Rx4 PC4 2400T QTY: 100 $20 each


16GB 2RX8 PC4-3200AA-UB1-11 Qty 100 $18

...............................................

Take all memory for $1,400

4GB DDR3 DESKTOP 86PCS

4GB DDR4 DESKTOP 100PCS

4GB DDR4 LAPTOP 50PCS

8GB DDR3 DESKTOP 64PCS

8GB DDR4 DESKTOP 143PCS

8GB DDR4 LAPTOP 165 PCS.





16GB 2RX4 PC4-2133P-RBB-10 Qty 85
8GB DDR4 PC4-17000 CL15 260-PIN SODIMM Qty 190
We are looking for a buyer to move all @ $1000 USD


Regards,
Justin Gates
Server Rack Equipment
1343 No. 5 Road, Richmond,
British Columbia
V7A 4G1 Canada
Phone: +1 7783083945 | Fax: 778 308 4563
