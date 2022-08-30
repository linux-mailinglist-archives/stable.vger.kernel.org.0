Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A04C5A58FE
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 03:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiH3Bt1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 21:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbiH3Bt0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 21:49:26 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A412B8C031;
        Mon, 29 Aug 2022 18:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1661824163;
        bh=APkWHONOOsMlMLqkXQ+RplJsCNDlGohYVVId0a6QBm8=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=cvkpbFOyAobD8ABYzckyFlYpJDS9VweM9H+uYJMvafiNbWVTydLOsCBeN+uxQ7KxN
         xZz0GQ6qit8kXRbyGQc87hWWXHfNh8rk6x91HewB503WYNey9Mp8TcL2UCejb4SE5F
         R0RQxtHh+x9o6rzl3IJqGAe0VMVhiMv1VyLq6E+U=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.35.249]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MNKm0-1on8QK43lC-00Os3Z; Tue, 30
 Aug 2022 03:49:23 +0200
Message-ID: <c31a35dd-a0ee-9b0e-65c8-d0af8f3e360e@gmx.de>
Date:   Tue, 30 Aug 2022 03:49:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 5.19 000/158] 5.19.6-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:m4LgMsH0jPpzVjvXvjIM2D8kQY0EIxAeJBc0Vzv0rx5V/fCoGrx
 Jo3KsvWrY/TaRhqGG8joNqEIk3L+hSQQrzPqLkThETP+OtRaHuDKkkrTb/fOB0ePBHoBv/K
 4zjUmBklCnrG2kp9XD0d57+pII6uIYNHSEneZjQ/eM4nDrVwQJUUsBxbSg6es5VtS/yDRND
 YgvQH0CVFPHFFsKv+vjuQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:ZDsgUneag+k=:7DQKaul0qd+PlsJO9vOx4D
 secWJTHczdt6EqWF+T8KqTvIAYuP9y35xVe7rlcPn2aNkj/oyXGaaqtcSRxMFCbnqmOmXwR/e
 zS9r/EW+yzNaKZXU4HWW++ljBLFsPELS/7CQJe5a7hcGO1RUYZSM4vlX0d0I6Lh4WA+m/ayGh
 hQNlWXWTs2jSusmLifbzXAtQbBLpJQ/miWpzUc5Pc8nAR+gVd4OE4geWpm1F8Rnj36kXhfMY0
 W87ZkXv0kbFhJTYSrx1dsNS6E5OeicdF93WM+L/gxWUAXRl+Jm011hk+Whnoq6hYHwvgYLb1N
 F7mIDgH66bOIGxxWOGz39IphOk+AsDo9gQs/JgzBXPGaQspabGaFc/28seEB9/aY0K+OpnHrc
 8mERoQHHTmmaRiFpvQcqd5mUUARASPALtQbIBQNA1nvLC6ytYCRn7fKmT9lap5Q5TVcl3G+Fj
 WRRw1S+LaBsPlSR5uTYu/EKhWq7VI1t/eBp1FwUM7vicxRUczNgdh+AgNrwxTOWjf5lTvB4hS
 mXhoydCgz0t3MKL0LvxaBlxweA/OFItrJu5gvMTE1EcWmC9KE9r56AgfAlXW8V693884KfVa5
 xQHEeNxl7Lunwz3vsDLkr3khi8QNZviuJ5m3MH5h0JRO6nzKkMcjMOqQPmLKl8GjwrnagYVz+
 scOmFVlIEKnfN/a+qGkYjNrcGwAnDJzntBwXvIcdgQXn/MbGMRZ8oTCdLEFQ9zFEED1agl9CC
 DhHL3ylI9uLOOFRllBzt+G/g4D6JnBl0X8UwNoMSwvNyOBq0nmBq2NtFQuMFApCzbAgg+g3Lw
 aObj6g/4RBubtTM7DFcBxXpgv7Q7iXXV6NITE1/9o5/RQjceDdj0jZ2iH1GVon/DBN/fJEIYC
 3RLY7vOXZkWG81b+g6SuozbqJI2r21bGgcxcQpP/G5qHGkNX7jGWPW9inqQIpP2gOQaG/EWNl
 MUeNw009aoTdNzt15oGepz1IaL6h2yLoGUQ1cppmKaaOiq7Iicrx67R0zC4IUCenSUlyDnyJd
 zKuGPCvGR2gXfMw5Hxd5kekM9H47AS74JKcPk20XruX+Q1g58CiMFLs9k1dXuMJkS6cR6ZaQF
 RMKcBcTRSoFLxlEI3c2IWmgqTgcz8qhGk29O47Uhm8PxYPqtv63loJymQ==
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hallo Greg

5.19.6-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 36)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

