Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A33359E9F5
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 19:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232463AbiHWRnV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 13:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbiHWRmv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 13:42:51 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06298BE09;
        Tue, 23 Aug 2022 08:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1661268677;
        bh=6y871TwjlGWu4Hn5isuPKP7hEDPU3mcdk7uvzqUMGlc=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=dElczNUP7M43ZNpUb5kqCWNp15vxyrnsfHh1zMwiDbRDOXuGZcwAs6oQ19mQwQHRY
         Q9wzGqOhtn8u+TF8mF+uD2zqPSFvKlxPXHXVELq51tpLoCrEch0imuesUmW9yhiyE+
         dYhk/OKH4mJL/6FXL0XJOMSQm/SBXH30/HiqZU0Q=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.34.177]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MbzuH-1p1VeN3gGV-00dV1S; Tue, 23
 Aug 2022 17:31:16 +0200
Message-ID: <41808495-4002-9dc9-8143-bdc6fb7f4394@gmx.de>
Date:   Tue, 23 Aug 2022 17:31:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 5.19 000/365] 5.19.4-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:OToLyasaT6alezisQuuvDFUZbsCpq4mPTtNw9MmXeW0G+HRIgpO
 vz9zt0i2PABQWZARfnQNqujE/2LYIS8DJUhsUQuQFjbz6njQoq5GPNi3EpX+mN2z50v8Rkb
 jBftcioU/pqGATgAIQtjphGrlOfUcWc1NwywzPr4CmytgFHtKhc6WaFgxA9wNKbuWEgRPMJ
 n8YeJHDAzrhse3LqKXEyA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:PjpAwpzMs2w=:iCr72FgZzSXb6wZ4MpggmI
 qGe0NyxnoaP9faSdSGke6hhxnBZBP/LYvb4nAOWB1A1gq35TmT4UfaEctYQiRnUeeXPv+jodO
 ySWVwkxwlar1JUA+ijeoSiRrMRVCUlmm6tlbvyhM35cIYop7nGsVBWnuYXUOSt6159uq4KzYf
 EtLwG/TkVNvRHsSR6YhegzsLL3iWFb8/jzQkhlef+DnaQaewZrEeq8+B/gLiWbHAp++FshGAl
 RzC04Oumpem1goy4sCtKfQLlyNS6rpuCaanUYbWfr3fik8FTi0lwZfqcfhK49W5YpbsDL0rC+
 QZaedtNytL/s24v/Fmo7LFcBogU94zQr+M1m5TaKmB3FoAv5GLYGCtc1NbSXtWt5VLFag8ZdK
 dygtKKlwKYdwJ+0U5M+tc9sS3+WiWbUCO+1Lh2nZs5f5YhhY+1XzV0S0CzQKGDyxaVIvrCNvI
 u17JMAMQkVX71j9Notc+8+z29q9VB79fkekq1AjUfLxD4ZMoUmJ8RML+wN7s+9JThPfvoVI7J
 DO1h5/k4kjDWaJwpqGzKCHJABVRYpb6aI/6BEoidDxkchaMxfu18+7zz/ElBfSFQqCYYaSzYi
 RfPs0WYmmSEEQ2Tv0btkqPW8x5G+si0M8B00l2z38beRtRi4rO/dtIk7MupW66/yxfzQdZkU/
 yc1HP8D5ok2qDMRjMcLh1yyu85rEcN6RdCTsbDLi+c4GFkvfisFVxrOXMqoc8Tn4kwgAVi7SK
 U/u+B/7wxDxg9hWwzTpkdlUVjr9TfuE4PHpp6i/hZdwJOEABaBO+8a0YmpYTflFb0U7VxwjMh
 MNm3AxeYxvLyGxBcwrSMdH7qDZ47J7GA/11r6on3U4k3nX0315T6A8yKarGlTNSDqUWadTFYo
 Ma4CwXlggrPFBsOhYUqQoCpkRNYzx3w4Xknf5plME5xl1jmI9rXG5lFtU0AadLLdWLZBgGiJx
 5lAN7Ku28mPrzzF039VSjj0dDRPQdlZjdBF9OXDttXbGcLfXjiL8QiuN/ZhN0LdC0QrKS6VOi
 ZcGSC+rEZ9hwsXrVzRooT32JM9s9J0jMxRgmSSupaD0NY0S3pNkHzIo+OXUtVn1S3St5Wbd14
 Ar/+iyW4WmXH1UQoHBzyb4/pWxn6JfEwIn7uzzXFUNUkpEmPiNkqgip+w==
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

5.19.4-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 36)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

