Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24F176DF86F
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 16:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbjDLO2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 10:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbjDLO2R (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 10:28:17 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E0B2D46;
        Wed, 12 Apr 2023 07:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1681309685; i=rwarsow@gmx.de;
        bh=NoDxyO+RfjMEcHznS/rod18wWdEUQrsMjf1lVtZiC7w=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=Tlo5TToICrdLP1LLyDp+Dy8pPExIHFLb1TzFk9CF0qN0M4l+Z8cObQXMWYqpIaN4U
         hkJWJ2bs7C7FJ8itz8ssXGvY/0sHa48OD7J1bukGMCKKEt1dIHXx2RfP23DPxm0pHb
         HtOpS4OO1SrJlUHrRnVMhg3UXeUf9gPX1aXCrgjrh+At8qfZ9XKn/e0ZSg2rdRAfjw
         mzLLzmatdbGDBsPijGR9egq2SEOfYKLGvnWy+iSiYAL6ZiDI3LIh3ABpnpxyqhiVUv
         zJLGmdm4iY377ITH1tEtagQHkpqZFPwlZiD0KOJPFpQSX8mGw9pscz2vO0pmetafQu
         I8zeO6ykjkTqg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.100.20] ([46.142.34.104]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1Mz9Z5-1qYdQk29eF-00wDYv; Wed, 12
 Apr 2023 16:28:05 +0200
Message-ID: <bff3fc44-d4b7-e1b9-4c7d-7bf478994810@gmx.de>
Date:   Wed, 12 Apr 2023 16:28:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE, en-US
Subject: Re: [PATCH 6.2 000/173] 6.2.11-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:TOYcClmMigWqbzZN8z7zEl6jF4IO1plBXGWyyS87wqZIixfF2OJ
 mpKA8fJR6XMiWuHva3e5u7ApMvsP4+OtQ7p/cQe/3xSGk/1jWUHCaZjesvBwND7uJH1z6+2
 r8ZCDZ7zatQqArzj+MmC/3/Oojb5bBzuQJZShJ1bqoM6pdFyunO4NjHScakZovu+Pt5IwnD
 1YiiRGcZOdrV1eVcpqusw==
UI-OutboundReport: notjunk:1;M01:P0:9eCE+SpgBPc=;+xeY63a8iDZ6YPxk07xNtoRS9UW
 1lHoM8QR5pUuP8J80XnALRo75cgk1Qr4Fb4lp0GVCxe3JAT5KRvkmNuXNdnbJBHZY5MT9h+cx
 3ZpeQxqritv0DqJ1KjrlRA6fjya9hjWCjJZ0jmw04UjgfrkC/+GjvLV2u/qhyI9elyIMOUFch
 7e6Y95XqGpj3gStIas97GtSgcefO1x1fJ1/nj7vUYgFAhAcid3UaKRq3ZqUmaP7fORW+oK+3Y
 JF3g8xixs5L+HwXAMaGRCf2OOQJpFG9TWa6bWH6Es0jVhInm1DlXSETpNtsFSZ2N3A9Zh0ODF
 i4qk4CtQurvl+XiGkEDuS83pq3SHyz0GItTSCniyTdHG082SYtxSXZfYyVoTjMTXt0gNg+9Oc
 EVF4Ag3B42btKd8RTROjaIIGRIVqHVoclGLYVOIu/DKWGJmnDRdc4L4WXM4FDQanMrZEdSviK
 C2SyVnMRXZy2Ify1BySvPtbV4nOy7bwapXkygcYsQKHiBKSg7n5KPvf8vcaTz0WIKWe7dVkDZ
 uWZ8RnbEA97K8UrDlHiMOk6jhPg3pevLKFh42EsDkk4ZecsuExOxH+eJM6apt3ea+IGqFRwQh
 5GSpXlYmhYLojR5rtOxn07j0VBuiOHH/Vq5skKNRXCMpJeq80GjicoiqUfObhZKld4KUqttK+
 5uNOACgoQwreJne9LewU6BvI9jB5h11Xmi7F+2ofWvL7ELTc3h784lpzAtyQw6hFOd5eyn0hS
 qJHFpf8ZhQlwP08Ga9blh8uIt5/KwT84fcKVG84PSVpziDSi3OlmFbn0nbMIA5cK3raF+acJk
 ZZsT24MdzZt2VBcQafa9itiqQ6sF/QZi0jZUTTl6N1KqojHi+o5nykY0tZtDLR4/L07w++inE
 VvInNWUNilAJAVSKuWiAn2+aKHfJA3dMU/vSL2zCybsjjA6kZMEiZEdOEwDNUWLchZc4wAc+d
 P8lbIA==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg

6.2.11-rc1

compiles, boots and runs here on Intel x86_64

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

