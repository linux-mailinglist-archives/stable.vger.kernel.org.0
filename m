Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC0E570CAA
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 23:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbiGKV11 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 17:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiGKV10 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 17:27:26 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 478E8326CC;
        Mon, 11 Jul 2022 14:27:24 -0700 (PDT)
Received: from [192.168.100.20] ([46.142.32.91]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MRC7g-1nwlKw2WOK-00N6Ay; Mon, 11 Jul 2022 23:27:22 +0200
Message-ID: <0506af84-fedf-d431-3cd3-811c559d3776@online.de>
Date:   Mon, 11 Jul 2022 23:27:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
From:   sixpack13 <sixpack13@online.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 5.18 000/112] 5.18.11-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:cGLX+dILWc0H2wIBTYsDx/alFcq90Yml5zBCuCySNSC7n9TmvmT
 Fd7BVr0L+gzzmqvNomnLt3JtNB+K6SMOVENWNtN/pZY6BeThxwvzKzXiuyul/nUv1kg8t7c
 iOTR7L3eYntvpFrevJjLNwx7Cazgcnv7nqltSKDL5t3oSIVuabNE2w/UwJccgJ54Mzu3o8i
 buIh6JvW1g5ivXKxwb69w==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Et0tlnx+zYs=:aM9KfIhn7E8MuBUqlEjhqu
 2hJqzIxj0RkQXw8pTlNbN2BC9QgXB9HsiRE2RfDiDsuzl1HBX2w0+fNcWGNtaDMgINjfonWp0
 u9FEG69BOg45zQ1xt/mtsUteGFTqZMLUySnJDRJiq7aKb0dEjaRNZPKToBvEsLYV53vE0PMRV
 o7hA1aUZ+c8PrtEM8HHhdThAlpDkijK1nTbIOcIhtXXlOYwRsY54++Htwxcc0Fo4F1d+hzFBM
 4XnCX2CpDi1wnETNEckseeN2+acJyz0OtojKc25BFcg0SLC3VqdtyPte+YqG/t7Jwh17UYNq7
 vyxjvGYyckvccM8VszPHhTrZGY5i3diKcQA5Y4OI6JZu45rQ4Yfdvcpy8VGfUvTJlZ/BS9kNG
 OaH7GFJSTCferBPJzpV3wknNYA/qCEZ5lbq5Ji6n7M+fjR4iY21hrNdSitc3O6tynfl7lIPS2
 cwCOdUePb1gkj0Q22+KZpUbqECj/zNOtr5P0qhhhT50yj+Z85cU7OFrDCTCaEftllmqh+XkoK
 ZURa8pK1OgjtCswgDjqY3s/09TOZUm1lK2ZkEgOE0UMhzUOrmyutSEehXho7CEyQ/JquTNiIU
 6SC0jH8Cw8YwtqfDp6BhQYqsULN+mHOwOCfqubfVZKHyc8DAXb5oVHTq0UY44iaF3sgpFmzlY
 GvrIuA2lhpXFz9fWrbxgZBUA/uSSh+GCTsk8JsMjIzwFyaq2VQHcCddm3hxXGfVPciyF+jQRQ
 GBGP/jNLTq0dpe5lMGrkCDnXC2RRoV31mpUWZQ==
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hallo Greg

5.18.11-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 36)

Thanks

Tested-by: sixpack13@online.de

