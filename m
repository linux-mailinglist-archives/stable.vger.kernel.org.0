Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD23363F34B
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 16:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbiLAPDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 10:03:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231573AbiLAPDH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 10:03:07 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1FC22338A;
        Thu,  1 Dec 2022 07:03:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1669906984; bh=d6cWltTKPKKcoYFeo2jR5Iogto95UiAMwN3hCqMCW5U=;
        h=X-UI-Sender-Class:Date:From:Subject:To:Cc;
        b=PZRhTnJs1qJhr7+es3FpknuPXhTYudGYKiIgHTcqsMkpOPMMfqwtwpgP5w4gDfxjg
         hwEkZuUPLhq/YItUZmRFPKDtb4sFU4mDV+l9Dj6jbq4KwuEuIiBI292WPfLCdK7nKD
         uNcZBcRKrEtv4UMjOlBeV1E8UvRbXY+Krmuv07ikRxiCuj0dWtI+5XM4xRm5FEcSIK
         HADTya31CSk7dr1lXANOz9I5tSSFAhadoN7IiXlPT4jb7plkXsS6o+P6lRLGfUDYqV
         cXFaRgoLH6v1OFqdF4Ylup09XcdQ5/T5MSTUCvgRmxHpNo8S9G5N0xmi9b9VDHB2q3
         wzeb5B/CAb7Gw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.100.20] ([46.142.33.165]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MoO6C-1ocU1A0AEi-00omjE; Thu, 01
 Dec 2022 16:03:04 +0100
Message-ID: <8468add6-b48c-983f-a4e8-2ae7cee70e91@gmx.de>
Date:   Thu, 1 Dec 2022 16:03:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
From:   Ronald Warsow <rwarsow@gmx.de>
Subject: Re: [PATCH 6.0 000/280] 6.0.11-rc2 review
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE, en-GB
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:R7Ip48eIWl2md0vfPIe0qQSzprtqz3pqbd4KKISzjKWvmvs2aeC
 nnMDSGrYSTMNBAQ1AhRG8HlFisXUzkTQz37fmdRsBwsUrYLLRelZ+DvNQaSn8La6dNTA93r
 1rSlPBF0xqjWRo4x2vm1Ar0SS16kNTeIYj7gSKXLpfuvrLObRg4zUuy0r+e5CAyia8WcwU3
 pvVVMe+e6bIsW3hTsyC3w==
UI-OutboundReport: notjunk:1;M01:P0:Q6EapbfGjb4=;k58pp8fdnEzJVVC8RmVZ48v2ViW
 cgysPibnHZR5otqFmWqrpDU5VKzYYOkNQhjtWMo2OdV5C6zgdT3ZqYdZthUBplpYc10eWadt8
 cykyBrwMycXv9LERqEkqP8N+2ugUbbgWcum3OzqCpY1JZgeXbuLt8ewQd2jUmegi6SYHV+7uj
 m6fq21juC6SIrMdFWPXisLP2qFXHXGwIW1ak730Lf8JDuhIGR65evd8D+aPxP8s+IWiJ1FMPN
 PfwVz9DEcps7CNVSdJSwrjCimvqKSzjYxpZJEpuVWD7GvvnztIeo1QEr+Ul4OyLfXN8i7oP5X
 fgcR8cpEtDEa8hezS300Hr6Fr1nu8YYAEaKx0xibPqH/NewJq0VI0dwcOCHY1/1otjIFYCpfn
 ulzX2I9M++Ktl3GaAv0zAaopOgxr8L1h0ciJB6+eyxx9Ia/kju2NJhJ+g9lcG4jHEmxGzIgXN
 urWTBk+tZ/oa+hVAAJzBDfrn7+Mh1hJxrLeldfbyP04kibezGFafDDeo3g6YLtgAqfhvim8QX
 oB2MWzbKiUNqj4Li9FmkH3tNEV2ldnLwEDRljtqHGsOlrmFaDXFypMy6QejOJM7k2vdiy2Fy7
 6bJYbM9Kp4kWOvlf1r6chpjOR8Nq7/Fw4m85kICB3RcuTO68u7wOTuYnpF31TGa5AA5TAdCwI
 X2Hsh6EyiK3YBk/mWfNVg1dCl8xQmbVlX7WMWufoLLQOabhytOGJaO3hyYr1dUXSfgdUxoDPO
 l7oCN1GJ0Nu9RJuNC1nFeXvHkuhLdZzY5WTWlW6Sbc3CMuZFQeSJej3hYqmaHHtmRgLVWSkOd
 H2/vI4WO4ln6E14C7t47zT8/UDyPlncBirghja6PqvTB1RGB1M5ImPQAYYqtg54yi3vZUIyC/
 Z7fQ1tQY/RGj5tUjuqDQqFoS8asyYgYcKHWyQIo6z7VXmeK2txr1ccwFAB35n4m0NGZ44uVao
 jFaHiYcNM32f9voOktR1NIenx88=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg

6.0.11-rc2

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 37)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

